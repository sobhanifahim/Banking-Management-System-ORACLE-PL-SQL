-- Create Sequences
CREATE SEQUENCE customer_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE account_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE transaction_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Tables with Auto-incremental IDs
CREATE TABLE Customers (
    c_id INT DEFAULT customer_seq.NEXTVAL PRIMARY KEY,
    name VARCHAR2(100),
    address VARCHAR2(255),
    phone VARCHAR2(20),
    nid INT,
    customer_image BLOB
);

CREATE TABLE Accounts (
    acc_id INT DEFAULT account_seq.NEXTVAL PRIMARY KEY,
    c_id INT,
    balance NUMBER(10, 2),
    last_transaction_date DATE,
    account_type VARCHAR2(255),
    FOREIGN KEY (c_id) REFERENCES Customers(c_id)
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    acc_id INT,
    amount NUMBER(10, 2),
    transaction_type VARCHAR2(10),
    transaction_date DATE,
    FOREIGN KEY (acc_id) REFERENCES Accounts(acc_id)
);
CREATE OR REPLACE TRIGGER update_last_transaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    UPDATE Accounts
    SET last_transaction_date = :NEW.transaction_date
    WHERE acc_id = :NEW.acc_id;
END;
/
-- Package
CREATE OR REPLACE PACKAGE banking_pkg AS
    PROCEDURE deposit(p_account_id INT, p_amount NUMBER);
    PROCEDURE withdraw(p_account_id INT, p_amount NUMBER);
    FUNCTION check_balance(p_account_id INT) RETURN NUMBER;
    FUNCTION total_customer_balance(p_customer_id INT) RETURN NUMBER;
END banking_pkg;
/

CREATE OR REPLACE PACKAGE BODY banking_pkg AS
    PROCEDURE deposit(p_account_id INT, p_amount NUMBER) IS
    BEGIN
        UPDATE Accounts
        SET balance = balance + p_amount
        WHERE acc_id = p_account_id;
        
        INSERT INTO Transactions (transaction_id, acc_id, amount, transaction_type, transaction_date)
        VALUES (transaction_seq.nextval, p_account_id, p_amount, 'Deposit', SYSDATE);
        
        COMMIT;
    END deposit;
    
    PROCEDURE withdraw(p_account_id INT, p_amount NUMBER) IS
        v_balance NUMBER;
    BEGIN
        SELECT balance INTO v_balance
        FROM Accounts
        WHERE acc_id = p_account_id;
        
        IF v_balance >= p_amount THEN
            UPDATE Accounts
            SET balance = balance - p_amount
            WHERE acc_id = p_account_id;
            
            INSERT INTO Transactions (transaction_id, acc_id, amount, transaction_type, transaction_date)
            VALUES (transaction_seq.nextval, p_account_id, p_amount, 'Withdrawal', SYSDATE);
            
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Insufficient balance');
        END IF;
    END withdraw;
    
    FUNCTION check_balance(p_account_id INT) RETURN NUMBER IS
        v_balance NUMBER;
    BEGIN
        SELECT balance INTO v_balance
        FROM Accounts
        WHERE acc_id = p_account_id;
        
        RETURN v_balance;
    END check_balance;
    
    FUNCTION total_customer_balance(p_customer_id INT) RETURN NUMBER IS
        v_total_balance NUMBER := 0;
    BEGIN
        SELECT SUM(balance)
        INTO v_total_balance
        FROM Accounts
        WHERE c_id = p_customer_id;
        
        RETURN v_total_balance;
    END total_customer_balance;
END banking_pkg;
/
