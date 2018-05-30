-- 存储过程

CREATE OR REPLACE FUNCTION insert_first_time_by_blocks()
RETURNS VOID AS $BODY$
DECLARE
    rec RECORD;
    query TEXT;
    fir INT;
    tt RECORD;

BEGIN

 query := 'SELECT id, addr FROM eth_addrs WHERE first_time IS NULL';

 FOR rec IN EXECUTE query
  LOOP
    RAISE NOTICE '----> eth_addrs id: %', rec.id;
	fir := (SELECT timestamp FROM blocks WHERE coinbase = rec.addr order by timestamp asc limit 1);

	IF fir IS NOT NULL
    THEN
		UPDATE eth_addrs SET first_time=fir WHERE addr=rec.addr AND first_time IS NULL;
    	RAISE NOTICE 'update ok,  first_time: % addr: %', fir, rec.addr;
	ELSE
    	RAISE NOTICE 'skip';
    END IF;

  END LOOP;

END;
$BODY$ LANGUAGE plpgsql;

-------------------------------

CREATE OR REPLACE FUNCTION insert_first_time_by_txs()
RETURNS VOID AS $func$
DECLARE
    rec RECORD;
    query TEXT;
    fir INT;
    tt RECORD;

BEGIN

 query := 'SELECT id, addr FROM eth_addrs WHERE first_time IS NULL';

 FOR rec IN EXECUTE query
  LOOP
    RAISE NOTICE '----> eth_addrs id: %', rec.id;
	fir := (SELECT timestamp FROM txs WHERE from_addr = rec.addr OR to_addr = rec.addr order by timestamp asc limit 1);

	IF fir IS NOT NULL
    THEN
		UPDATE eth_addrs SET first_time=fir WHERE addr= rec.addr AND first_time IS NULL;
    	RAISE NOTICE 'update ok,  first_time: % addr: %', fir, rec.addr;
	ELSE
    	RAISE NOTICE 'skip';
    END IF;

  END LOOP;

END;
$func$ LANGUAGE plpgsql;
