/* projectc 2 is 
managing the installments for each contract by: 
- checking the number of installments for each contract
- adding the installments with right date and amount to the installments_paid table 
considering:
- that the client payes the first installment in the day of signing the contract
- the deposite is minused from the total_fees before calculating the amount of installments */
CREATE OR REPLACE PROCEDURE project2
IS
    CURSOR contracts_cursor IS
        SELECT * FROM contracts;
        
    dominator NUMBER(8,2); -- number of installments other than the first deposite
    months NUMBER(8,2); -- number of months between contract start and end dates
    deposite NUMBER(8,2); -- the deposite to pay as the first installment
    installments NUMBER(8,2); -- the fees paid each month, year, half-month or quarter
    added_months NUMBER(8,2); -- number of months added to the date when inserting in the installments_paid table
    
BEGIN
    FOR contract IN contracts_cursor --loop over every contract
    LOOP
        months := months_between(contract.contract_enddate, contract.contract_startdate); 
        dominator := calc_installments_num (added_months, contract.contract_payment_type, months); 
        IF contract.contract_deposite_fees IS NULL THEN
            deposite := 0; -- replace null by 0
        ELSE
            deposite := contract.contract_deposite_fees;
        END IF;
        installments := (contract.contract_total_fees - deposite) / dominator; 
        insert_installments(installments, contract.contract_startdate, contract.contract_id, dominator, added_months); --add installments to the installments_paid table
    END LOOP;
END;
show errors;
