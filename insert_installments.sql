/* insert installments record into the instalments_paid table  
the procedure takes:
- installment_fees --> the amount to pay every installment
- start_date --> start_date of the contract
- contract id
- dominator --> number of installments for each contract
- added months --> the number of months to add to the previous installment date*/
CREATE OR REPLACE PROCEDURE insert_installments (installment_fees NUMBER, start_date DATE, contract_id NUMBER, dominator NUMBER, added_months NUMBER)
IS
    v_current_date DATE;
BEGIN
     v_current_date := start_date; -- for the first installment the date is the contract start date
    FOR installment_num IN 1..dominator -- loop over the number of installments
    LOOP
        INSERT INTO installments_paid
        VALUES (INSTALLMENTS_SEQ.nextval, v_current_date, installment_fees, contract_id, 0);
        v_current_date := ADD_MONTHS(v_current_date, added_months); -- add the number of months specified to obtain the date of the next installment
    END LOOP;
END;