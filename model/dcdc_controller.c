/**
 * \file
 * \brief Motor Force Controller
 * \author Uros Platise <uros@isotel.eu>
 */

#include <stdint.h>
#include <stdio.h>

#define DESIRED_VOLTAGE           (30*2.2/100*4096/2.048)
#define REGULATOR_SCALE_SHIFT   6       /// Kp, and Ki are multiplied by 2^6

/**
 * Function is called at A/D Sample Rate, and accumulates 64 samples, then
 * executes simple PI regulator and outputs an 8-bit PWM.
 */
uint8_t dcdc_controller(uint32_t sample, int32_t Kp, int32_t Ki, uint8_t reset)
{
    static uint8_t ad_sample_count = 0;
    static int32_t sample_acc = 0;
    static int32_t integ = 0;
    static uint8_t pwm = 100;

    if (reset) {
        fprintf(stderr, "Firmware Reset\n");
        ad_sample_count = 0;
        sample_acc = 0;
    }
    else {
        if (++ad_sample_count > 32) {
            ad_sample_count = 0;
            sample_acc >>= 5;

            int32_t e = DESIRED_VOLTAGE - sample_acc;
            integ += e * Ki;
            int32_t out = (e * Kp + integ * Ki) >> REGULATOR_SCALE_SHIFT;
            //pwm = (out > 255) ? 255 : (out < 0) ? 0 : out;

            // simple controller for testing
            if (sample_acc > DESIRED_VOLTAGE && pwm < 200) {
                pwm++;
            }
            else if (pwm > 1) {
                pwm--;
            }

            fprintf(stderr, "I = %d, e = %d, integ = %d, PWM = %d, desired: %d\n", sample_acc, e, integ, pwm, (int)DESIRED_VOLTAGE);
            sample_acc = 0;
        }
        else {
            sample_acc += sample;
        }
    }
    return pwm;
}
