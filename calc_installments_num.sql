/* get the number of installments based on the contract-type --> dominator and 
get the number of  added months to the start date or previous date for each installment  --> added_months*/
CREATE OR REPLACE FUNCTION calc_installments_num (added_months out NUMBER, contract_payment_type VARCHAR2, months NUMBER)
RETURN  NUMBER
IS
    dominator NUMBER(8,2);
BEGIN
     CASE contract_payment_type
            WHEN 'ANNUAL' THEN
                dominator := trunc(months / 12);
                added_months := 12;
            WHEN 'QUARTER' THEN
                dominator := trunc(months / 3);
                added_months := 3;
            WHEN 'MONTHLY' THEN
                dominator := trunc(months);
                added_months := 1;
            WHEN 'HALF-ANNUAL' THEN
                dominator := trunc(months / 6);
                added_months := 6;
            ELSE 
                dbms_output.put_line('Unrecognized payement type');
        END CASE;
        RETURN dominator;
END;
show errors;