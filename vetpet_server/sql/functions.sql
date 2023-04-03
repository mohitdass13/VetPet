
CREATE or REPLACE PROCEDURE store_otp(IN email VARCHAR(50),IN new_otp INTEGER)
language plpgsql
 as $$

BEGIN
    INSERT INTO otpstore 
    VALUES(email, new_otp, now()) ON CONFLICT (email) DO UPDATE SET otp=new_otp, request_time=now();
END;
$$
;


CREATE OR REPLACE FUNCTION verify_otp(email VARCHAR(50), otp INTEGER)
RETURNS BOOLEAN language plpgsql
AS $$
DECLARE 
temp INTEGER DEFAULT 0 ;
BEGIN
    SELECT COUNT(*) 
        INTO temp 
        from otpstore o 
        WHERE o.emailid=email and o.otp=otp ;
    if temp =0 then RETURN false;
    else RETURN true;
    end if;
END;
$$;


CREATE OR REPLACE PROCEDURE store_logged_in(IN email VARCHAR(50),IN api_key VARCHAR(20))
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO logged_in 
    VALUES(email, api_key, now()) ON CONFLICT (email) DO UPDATE SET api_key=api_key, login_time=now();
END;
$$;


CREATE OR REPLACE FUNCTION verify_key(email VARCHAR(50), api_key VARCHAR(20))
RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
DECLARE temp INTEGER DEFAULT 0 ;

BEGIN

    SELECT COUNT(*) 
        INTO temp 
        from logged_in l
        WHERE l.emailid = email and l.api_key=api_key ;
        
    if temp =0 then RETURN false;
    else RETURN true;

    end if;
END;
$$;