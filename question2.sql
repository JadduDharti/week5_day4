ALTER TABLE customer
ADD COLUMN platinum_member BOOLEAN DEFAULT FALSE;


CREATE OR REPLACE PROCEDURE update_platinum_member_status()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update Platinum Member status based on customer spending
    UPDATE customer
    SET platinum_member = CASE
        WHEN EXISTS (
            SELECT 1
            FROM order_
            WHERE order_.customer_id = customer.customer_id
            GROUP BY customer_id
            HAVING SUM(amount) > 200
        ) THEN TRUE
        ELSE FALSE
    END;
END;
$$;


CALL update_platinum_member_status();

SELECT * FROM customer;