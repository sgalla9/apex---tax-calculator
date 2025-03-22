CREATE OR REPLACE FUNCTION sg_calc_income_tax (
    p_income IN VARCHAR2,
	p_deduction IN VARCHAR2)
RETURN NUMBER
AS	
    ln_income_tax   NUMBER;
	ln_income NUMBER;
	ln_deduction NUMBER;
    ln_taxable_income NUMBER;
    ln_tax_exemtion_incoome NUMBER := 1200000;
    ln_slab1_lower NUMBER := 0;
    ln_slab1_upper NUMBER := 400000;
    ln_slab1_tax_perc   NUMBER := 0;
    ln_slab1_tax NUMBER;
    ln_slab2_lower NUMBER := 400000;
    ln_slab2_upper NUMBER := 800000;
    ln_slab2_tax_perc   NUMBER := 5;
    ln_slab2_tax NUMBER;
    ln_slab3_lower NUMBER := 800000;
    ln_slab3_upper NUMBER := 1200000;
    ln_slab3_tax_perc   NUMBER := 10;
    ln_slab3_tax NUMBER;
    ln_slab4_lower NUMBER := 1200000;
    ln_slab4_upper NUMBER := 1600000;
    ln_slab4_tax_perc   NUMBER := 15;
    ln_slab4_tax NUMBER;
    ln_slab5_lower NUMBER := 1600000;
    ln_slab5_upper NUMBER := 2000000;
    ln_slab5_tax_perc   NUMBER := 20;
    ln_slab5_tax NUMBER;
    ln_slab6_lower NUMBER := 2000000;
    ln_slab6_upper NUMBER := 2400000;
    ln_slab6_tax_perc   NUMBER := 25;
    ln_slab6_tax NUMBER;
    ln_slab7_lower NUMBER := 2400000;
    ln_slab7_tax_perc   NUMBER := 30;
    ln_slab7_tax NUMBER;
BEGIN
    apex_debug.enter(
        'sg_calc_income_tax' ,
        'p_income=%0,p_deduction=%1', p_income,p_deduction );
		
	ln_taxable_income := TO_NUMBER(REPLACE(p_income, ',', ''), '9999999999.99');

    IF ln_taxable_income > ln_tax_exemtion_incoome
    THEN
        IF (ln_taxable_income > ln_slab4_lower AND ln_taxable_income < ln_slab4_upper)
        THEN
            ln_slab1_tax := (ln_slab1_upper-ln_slab1_lower)*ln_slab1_tax_perc/100;
            ln_slab2_tax := (ln_slab2_upper-ln_slab2_lower)*ln_slab2_tax_perc/100;
            ln_slab3_tax := (ln_slab3_upper-ln_slab3_lower)*ln_slab3_tax_perc/100;
            ln_slab4_tax := (ln_taxable_income - ln_slab4_lower)*ln_slab4_tax_perc/100;
            ln_income_tax := ln_slab1_tax + ln_slab2_tax + ln_slab3_tax + ln_slab4_tax;
        ELSIF (ln_taxable_income > ln_slab5_lower AND ln_taxable_income < ln_slab5_upper)
        THEN
            ln_slab1_tax := (ln_slab1_upper-ln_slab1_lower)*ln_slab1_tax_perc/100;
            ln_slab2_tax := (ln_slab2_upper-ln_slab2_lower)*ln_slab2_tax_perc/100;
            ln_slab3_tax := (ln_slab3_upper-ln_slab3_lower)*ln_slab3_tax_perc/100;            
            ln_slab4_tax := (ln_slab4_upper-ln_slab4_lower)*ln_slab4_tax_perc/100;
            ln_slab5_tax := (ln_taxable_income - ln_slab5_lower)*ln_slab5_tax_perc/100;
            ln_income_tax := ln_slab1_tax + ln_slab2_tax + ln_slab3_tax + ln_slab4_tax + ln_slab5_tax;
        ELSIF (ln_taxable_income > ln_slab6_lower AND ln_taxable_income < ln_slab6_upper)
        THEN 
            ln_slab1_tax := (ln_slab1_upper-ln_slab1_lower)*ln_slab1_tax_perc/100;
            ln_slab2_tax := (ln_slab2_upper-ln_slab2_lower)*ln_slab2_tax_perc/100;
            ln_slab3_tax := (ln_slab3_upper-ln_slab3_lower)*ln_slab3_tax_perc/100;            
            ln_slab4_tax := (ln_slab4_upper-ln_slab4_lower)*ln_slab4_tax_perc/100;           
            ln_slab5_tax := (ln_slab5_upper-ln_slab5_lower)*ln_slab5_tax_perc/100;
            ln_slab6_tax := (ln_taxable_income - ln_slab6_lower)*ln_slab6_tax_perc/100;
            ln_income_tax := ln_slab1_tax + ln_slab2_tax + ln_slab3_tax + ln_slab4_tax + ln_slab5_tax + ln_slab6_tax;
        ELSIF ln_taxable_income > ln_slab7_lower
        THEN 
            ln_slab1_tax := (ln_slab1_upper-ln_slab1_lower)*ln_slab1_tax_perc/100;
            ln_slab2_tax := (ln_slab2_upper-ln_slab2_lower)*ln_slab2_tax_perc/100;
            ln_slab3_tax := (ln_slab3_upper-ln_slab3_lower)*ln_slab3_tax_perc/100;            
            ln_slab4_tax := (ln_slab4_upper-ln_slab4_lower)*ln_slab4_tax_perc/100;           
            ln_slab5_tax := (ln_slab5_upper-ln_slab5_lower)*ln_slab5_tax_perc/100;
            ln_slab6_tax := (ln_slab6_upper-ln_slab6_lower)*ln_slab6_tax_perc/100;
            ln_slab7_tax := (ln_taxable_income - ln_slab7_lower)*ln_slab7_tax_perc/100;
            ln_income_tax := ln_slab1_tax + ln_slab2_tax + ln_slab3_tax + ln_slab4_tax + ln_slab5_tax + ln_slab6_tax+ln_slab7_tax;
        END IF;
    ELSE 
        ln_income_tax := 0;
    END IF;
	
    RETURN ln_income_tax;
EXCEPTION
    WHEN OTHERS THEN
        apex_debug.warn(
            p_message => 'Unexpected error. ',
            p0        => SQLERRM);
        RAISE;
END sg_calc_income_tax;