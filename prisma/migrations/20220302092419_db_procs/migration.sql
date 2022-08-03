CREATE or REPLACE FUNCTION update_version_no()  RETURNS TRIGGER
as
$$ BEGIN
        NEW.version_no = old.version_no + 1;
return new;
end;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    t record;
BEGIN
    FOR t IN
        SELECT distinct table_schema, table_name from information_schema."columns"  WHERE   table_schema='public' and table_name not in ('_prisma_migrations') and column_name = 'version_no'
        -- SELECT * FROM information_schema."tables" where table_schema='public' and table_name not in ('_prisma_migrations')
    LOOP
        EXECUTE format('CREATE TRIGGER update_version_no
                        BEFORE UPDATE ON %I.%I
                        FOR EACH ROW EXECUTE PROCEDURE update_version_no()',
                        t.table_schema, t.table_name);
    END LOOP;
END;
$$ LANGUAGE plpgsql;