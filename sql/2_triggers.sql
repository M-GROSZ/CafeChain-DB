-- #@##@### Triggers for Cafe Database #@##@###

-- 1. CUSTOMER VALIDATION
CREATE OR REPLACE TRIGGER trg_customer_validation
BEFORE INSERT OR UPDATE ON Customer
FOR EACH ROW
BEGIN
    -- Initialize points (only on INSERT)
    IF INSERTING AND :NEW.Points IS NULL THEN
        :NEW.Points := 0;
    END IF;

    -- Validate phone number (exactly 9 digits)
    IF LENGTH(:NEW.Phone) != 9 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Phone number must have exactly 9 digits.');
    END IF;

    -- Always uppercase the first name
    :NEW.First_Name := UPPER(:NEW.First_Name);

    -- Points cannot be negative
    IF :NEW.Points < 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Points cannot be negative.');
    END IF;
END;
/

-- 2. PRODUCT DELETION BLOCK (Premium / Budget)
CREATE OR REPLACE TRIGGER trg_delete_product
BEFORE DELETE ON Product
FOR EACH ROW
BEGIN
    IF :OLD.Price < 5 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Cannot delete budget products.');
    END IF;

    IF :OLD.Price > 100 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Premium product deletion requires manager approval.');
    END IF;
END;
/

-- 3. CUSTOMER ORDER ACTIONS (Points & History)
CREATE OR REPLACE TRIGGER trg_customer_order_actions
AFTER INSERT OR DELETE ON Customer_Order
FOR EACH ROW
DECLARE
    v_new_id NUMBER;
BEGIN
    IF INSERTING THEN
        -- Add points
        UPDATE Customer SET Points = Points + 10 WHERE ID = :NEW.Customer_ID;
        
        -- Insert into history
        SELECT NVL(MAX(ID), 0) + 1 INTO v_new_id FROM Order_History;
        INSERT INTO Order_History (ID, Customer_Order_ID, New_Status, Change_Time)
        VALUES (v_new_id, :NEW.ID, 1, TO_DATE('2025-01-01', 'YYYY-MM-DD'));

        -- Date validation
        IF :NEW.Order_Date < TO_DATE('2025-01-01', 'YYYY-MM-DD') THEN
            RAISE_APPLICATION_ERROR(-20004, 'Cannot insert orders older than 2025-01-01.');
        END IF;

    ELSIF DELETING THEN
        -- Subtract points
        UPDATE Customer SET Points = GREATEST(Points - 10, 0) WHERE ID = :OLD.Customer_ID;

        -- Insert into history
        SELECT NVL(MAX(ID), 0) + 1 INTO v_new_id FROM Order_History;
        INSERT INTO Order_History (ID, Customer_Order_ID, New_Status, Change_Time)
        VALUES (v_new_id, :OLD.ID, 0, TO_DATE('2025-01-01', 'YYYY-MM-DD'));

        -- Date validation
        IF :OLD.Order_Date < TO_DATE('2025-01-01', 'YYYY-MM-DD') THEN
            RAISE_APPLICATION_ERROR(-20008, 'Cannot delete orders older than 2025-01-01.');
        END IF;
    END IF;
END;
/

-- 4. PAYMENT UPDATES (Points based on amount change)
CREATE OR REPLACE TRIGGER trg_update_payment
AFTER UPDATE ON Payment
FOR EACH ROW
WHEN (OLD.Amount != NEW.Amount)
DECLARE
    v_customer_id NUMBER;
BEGIN
    SELECT co.Customer_ID INTO v_customer_id
    FROM Customer_Order co
    WHERE co.ID = :NEW.Customer_Order_ID;

    IF :NEW.Amount > :OLD.Amount THEN
        UPDATE Customer SET Points = Points + 50 WHERE ID = v_customer_id;
    END IF;

    IF :NEW.Amount < 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Payment amount cannot be negative.');
    END IF;
END;
/