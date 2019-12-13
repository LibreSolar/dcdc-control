/**
 * \file
 * \brief Motor Force Controller
 * \author Uros Platise <uros@isotel.eu>
 */

#include <stdint.h>
#include <stdio.h>

#define DESIRED_VOLTAGE         (30*2.2/102.2*4096/2.048)
#define ADC_FACTOR              (102.2/2.2*2.048/4096)
#define REGULATOR_SCALE_SHIFT   6       // Kp, and Ki are multiplied by 2^6
#define TIMER_ARR               180     // defines maximum PWM setting

/**
 * Function is called at A/D Sample Rate, and accumulates 64 samples, then
 * executes simple PI regulator and outputs an 8-bit PWM.
 */
uint16_t dcdc_controller(uint16_t hv_adc, uint16_t lv_adc, uint16_t shunt_adc,
    int32_t Kp, int32_t Ki, uint8_t reset)
{
    static uint8_t ad_sample_count = 0;
    static int32_t sample_acc = 0;
    static int32_t integ = (200*12/30 * 2) << REGULATOR_SCALE_SHIFT;      // initialize properly;
    static uint16_t pwm = 200*12/30;

    if (reset) {
        fprintf(stderr, "Firmware Reset\n");
        ad_sample_count = 0;
        sample_acc = 0;
    }
    else {
        if (++ad_sample_count > 128) {
            ad_sample_count = 0;
            sample_acc >>= 7;

            // normal PID
            int32_t e = DESIRED_VOLTAGE - sample_acc;
            integ += e * Ki;
            int32_t out = (e * Kp + integ * Ki) >> REGULATOR_SCALE_SHIFT;
            //pwm = (out > TIMER_ARR) ? TIMER_ARR : (out < 1) ? 1 : out;

            // simplified controller
            pwm += (sample_acc > DESIRED_VOLTAGE) ? 1 : -1;

            fprintf(stderr, "hv %.3fV, lv %.3fV, i %.3fA, e = %d, integ = %d, PWM = %d, desired: %d\n",
                (float)hv_adc * ADC_FACTOR, (float)lv_adc * ADC_FACTOR, (float)(shunt_adc - lv_adc) * 500 * ADC_FACTOR,
                e, integ, pwm, (int)DESIRED_VOLTAGE);
            sample_acc = 0;
        }
        else {
            sample_acc += hv_adc;
        }
    }
    return pwm;
}
