CREATE OR REPLACE PROCEDURE add_late_fee()
LANGUAGE plpgsql
AS $$
DECLARE
  late_fee NUMERIC(10, 2); -- Variable to store the late fee amount
BEGIN
  -- Calculate the late fee as 1% of the rental price per day
  --late_fee := 0.01 * (EXTRACT(EPOCH FROM (CURRENT_DATE - r.return_date)) / 86400) * p.amount;
  
  -- Update payments table with the late fee for overdue rentals
  UPDATE payment AS p
  SET amount = amount + (0.01 * (EXTRACT(EPOCH FROM (CURRENT_DATE - r.return_date)) / 86400) * p.amount) 
  FROM rental AS r
  WHERE p.rental_id = r.rental_id
    AND r.return_date < (CURRENT_DATE - INTERVAL '7 days'); -- Check for rentals returned after 7 days
   
END;
$$;


CALL add_late_fee(); -- Call the add_late_fee procedure

SELECT * FROM payment;





