DECLARE
    ln_income_tax NUMBER;
    ln_tax_payable_m NUMBER;
	ln_deduction NUMBER;
	ln_salary	NUMBER;
	ln_pf NUMBER;
	ln_other_income	NUMBER;
	ln_exemptions	NUMBER;
	ln_taxable_income	NUMBER;
	ln_he_tax NUMBER;
	ln_total_tax_payable NUMBER;
    ln_net_income NUMBER;
    ln_net_income_m NUMBER;
BEGIN
	IF :P1_REGIME = 'NEW'
	THEN
		ln_deduction := 75000;
	ELSIF :P1_REGIME = 'OLD'
	THEN
		ln_deduction := 50000;
	ELSE 
		ln_deduction := 0;	
	END IF;
	:P1_DEDUCTION := TO_CHAR(ln_deduction,'FM999G99G99G99G990D00');
	
	ln_salary := NVL(TO_NUMBER(REPLACE(:P1_SALARY, ',', ''), '9999999999.99'),0);
	ln_pf := NVL(TO_NUMBER(REPLACE(:P1_PF, ',', ''), '9999999999.99'),0);
	ln_other_income := NVL(TO_NUMBER(REPLACE(:P1_OTHER_INCOME, ',', ''), '9999999999.99'),0);
	ln_exemptions := NVL(TO_NUMBER(REPLACE(:P1_EXEMPTIONS, ',', ''), '9999999999.99'),0);
	ln_taxable_income := ln_salary - ln_pf + ln_other_income - ln_exemptions - ln_deduction;
	IF ln_taxable_income < 0
	THEN
		ln_taxable_income := 0;
	END IF;
	:P1_TAXABLE_INCOME := TO_CHAR(ln_taxable_income,'FM999G99G99G99G990D00');
		
    ln_income_tax := SG_CALC_INCOME_TAX(:P1_REGIME,ln_taxable_income);
    :P1_INCOME_TAX := TO_CHAR(ln_income_tax,'FM999G99G99G99G990D00');
	ln_he_tax := ln_income_tax*0.04;
	:P1_HE_TAX := TO_CHAR(ln_he_tax,'FM999G99G99G99G990D00');
	ln_total_tax_payable := ln_income_tax + ln_he_tax;
	:P1_TOTAL_TAX_PAYABLE := TO_CHAR(ln_total_tax_payable,'FM999G99G99G99G990D00');
    ln_tax_payable_m := ln_total_tax_payable/12;
    :P1_TAX_PAYABLE_M := TO_CHAR(ln_tax_payable_m,'FM999G99G99G99G990D00');
    ln_net_income := ln_salary + ln_other_income - (2*ln_pf) - ln_total_tax_payable;
    :P1_NET_INCOME := TO_CHAR(ln_net_income,'FM999G99G99G99G990D00');
    ln_net_income_m := ln_net_income/12;
    :P1_NET_INCOME_M := TO_CHAR(ln_net_income_m,'FM999G99G99G99G990D00');
EXCEPTION
    WHEN OTHERS
    THEN
        apex_debug.error('Error occurred: ' || sqlerrm);
        RAISE_APPLICATION_ERROR(-20001, 'Unexpected Error occured.'|| sqlerrm);
END;