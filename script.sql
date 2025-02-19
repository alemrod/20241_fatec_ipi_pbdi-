-- Active: 1714478827335@@127.0.0.1@5432@20241_fatec_ipi_pbdi_selecao@public
-- equação de segundo grau
-- if/elsif/ else
DO $$
	DECLARE
		v1 INT := fn_gera_valor_aleatorio_entre(0,2); 
		v2 INT := fn_gera_valor_aleatorio_entre(0,20);
		v3 INT := fn_gera_valor_aleatorio_entre(0,20);
		delta NUMERIC(10,2) := (v2 ^ 2) - (4 * v1 * v3);
		raizum NUMERIC(10, 2);
		raizdois NUMERIC(10, 2);
	BEGIN
		RAISE NOTICE 'O a equação é %x% + %x + % = 0', v1, U&'\00B2',v2,v3;
		IF v1 = 0 THEN
			RAISE NOTICE 'Não vai rolar a é negativo';
		ELSE
			IF delta > 0 THEN
				raizum := (v2 * -1 + |/delta) / (2 * v1);
				raizdois := (v2 * -1 - |/delta) / (2 * v1);
				RAISE NOTICE 'o valor de delta foi %, e com isso chegamos as raizes % e %', delta, raizum, raizdois;
			ELSIF delta = 0 THEN
				raizum := (v2 * -1 + |/delta) / (2 * v1);
				raizdois := (v2 * -1 - |/delta) / (2 * v1);
				RAISE NOTICE 'o valor de delta foi %, e com isso chegamos as raizes % e %', delta, raizum, raizdois;
			ELSE
				RAISE NOTICE 'sem raiz';

			END IF;
		END IF;
	END;
	$$