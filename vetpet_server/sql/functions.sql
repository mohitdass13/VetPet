
CREATE or REPLACE PROCEDURE store_otp(IN email_inp VARCHAR(50),IN new_otp_inp INTEGER)
LANGUAGE plpgsql
AS $$

BEGIN
    INSERT INTO otpstore 
    VALUES(email_inp, new_otp_inp, now()) 
    ON CONFLICT (emailid) 
        DO UPDATE SET otp=new_otp_inp, request_time=now();
END;
$$;

CREATE OR REPLACE FUNCTION verify_otp(email_inp VARCHAR(50), otp_inp INTEGER)
RETURNS BOOLEAN language plpgsql
AS $$
DECLARE 
rem INTEGER;
BEGIN
    if EXISTS (
        SELECT
        FROM otpstore o
        WHERE o.emailid = email_inp and o.otp=otp_inp
    ) then RETURN true;
    else 
        UPDATE otpstore 
                SET attempts = attempts - 1 
                WHERE emailid = email_inp;
            SELECT attempts 
                INTO rem 
                from otpstore o 
                WHERE o.emailid=email_inp;
            IF rem = 0 THEN
                DELETE FROM otpstore WHERE emailid=email_inp;
            END IF;
            RETURN false;
    end if;
END;
$$;


CREATE OR REPLACE PROCEDURE store_logged_in(IN email_inp VARCHAR(50),IN api_key_inp VARCHAR(20))
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO logged_in 
    VALUES(email_inp, api_key_inp, now()) ON CONFLICT (emailid) DO UPDATE SET api_key=api_key_inp, login_time=now();
END;
$$;


CREATE OR REPLACE FUNCTION verify_key(email_inp VARCHAR(50), api_key_inp VARCHAR(20))
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$

BEGIN
    RETURN EXISTS (
        SELECT
        FROM logged_in l
        WHERE l.emailid = email_inp and l.api_key=api_key_inp 
    );
END;
$$;