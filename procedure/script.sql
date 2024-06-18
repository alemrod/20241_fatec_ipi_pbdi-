--- ativida ap11
-- 1.1 Adicione uma tabela de log ao sistema do restaurante. Ajuste cada procedimento para que ele registre
-- - a data em que a operação aconteceu
-- - o nome do procedimento executado
CREATE TABLE log_operacoes (
    id SERIAL PRIMARY KEY,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nome_procedimento VARCHAR(255) NOT NULL
);

CREATE OR REPLACE PROCEDURE sp_obter_notas_para_compor_o_troco(
	OUT p_resultado VARCHAR(500),
	IN p_troco INT
    OUT p_resultado VARCHAR(500),
    IN p_troco INT
) LANGUAGE plpgsql AS $$
DECLARE
	v_notas200 INT := 0;
	v_notas100 INT := 0;
	v_notas50 INT := 0;
	v_notas20 INT := 0;
	v_notas10 INT := 0;
	v_notas5 INT := 0;
	v_notas2 INT := 0;
	v_moedas1 INT := 0;
    v_notas200 INT := 0;
    v_notas100 INT := 0;
    v_notas50 INT := 0;
    v_notas20 INT := 0;
    v_notas10 INT := 0;
    v_notas5 INT := 0;
    v_notas2 INT := 0;
    v_moedas1 INT := 0;
BEGIN
	v_notas200 := p_troco / 200;
	v_notas100 := (p_troco % 200) / 100;
	v_notas50 := (p_troco % 200 %100) / 50;
	v_notas20 := (p_troco %200 %100 % 50) / 20;
	v_notas10 := (p_troco %200 %100 % 50 % 20) / 10;
	v_notas5 := (p_troco %200 %100 % 50 % 20 % 10) / 5;
	v_notas2 := (p_troco %200 %100 % 50 % 20 % 10 %5) / 2;
	v_moedas1 := (p_troco %200 %100 % 50 % 20 % 10 %5 %2) / 1;
    v_notas200 := p_troco / 200;
    v_notas100 := (p_troco % 200) / 100;
    v_notas50 := (p_troco % 200 % 100) / 50;
    v_notas20 := (p_troco % 200 % 100 % 50) / 20;
    v_notas10 := (p_troco % 200 % 100 % 50 % 20) / 10;
    v_notas5 := (p_troco % 200 % 100 % 50 % 20 % 10) / 5;
    v_notas2 := (p_troco % 200 % 100 % 50 % 20 % 10 % 5) / 2;
    v_moedas1 := (p_troco % 200 % 100 % 50 % 20 % 10 % 5 % 2) / 1;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_obter_notas_para_compor_o_troco');
END;
$$
$$;

CREATE OR REPLACE PROCEDURE sp_calcular_troco(
    OUT p_troco INT,
    IN p_valor_pago_cliente INT,
    IN p_valor_total INT
) LANGUAGE plpgsql AS $$
BEGIN
    p_troco := p_valor_pago_cliente - p_valor_total;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_calcular_troco');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_fechar_pedido(
    IN p_valor_pago_pelo_cliente INT,
    IN p_codigo_pedido INT
) LANGUAGE plpgsql AS $$
DECLARE
    v_valor_total INT;
BEGIN
    CALL sp_calcular_valor_de_um_pedido(p_codigo_pedido, v_valor_total);
    IF p_valor_pago_pelo_cliente < v_valor_total THEN
        RAISE NOTICE 'R$% insuficiente para pagar a conta de RS%', 
        p_valor_pago_pelo_cliente, v_valor_total;
    ELSE
        UPDATE pedido p SET
        data_modificacao = CURRENT_TIMESTAMP,
        status = 'fechado'
        WHERE p.cod_pedido = p_codigo_pedido;
    END IF;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_fechar_pedido');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_calcular_valor_de_um_pedido(
    IN p_codigo_pedido INT,
    OUT p_valor_total INT
) LANGUAGE plpgsql AS $$
BEGIN 
    SELECT SUM(i.valor) FROM pedido p
    INNER JOIN tp_item_pedido ip ON
    p.cod_pedido = ip.cod_pedido
    INNER JOIN tp_item i ON
    ip.cod_item = i.cod_item
    WHERE p.cod_pedido = p_codigo_pedido
    INTO p_valor_total;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_calcular_valor_de_um_pedido');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_ad_item_pedido(
    IN cod_item INT,
    IN cod_pedido INT
) LANGUAGE plpgsql AS $$
BEGIN
    -- Insere novo item
    INSERT INTO tp_item_pedido(cod_item, cod_pedido) VALUES (cod_item, cod_pedido);
    -- Atualizando data
    UPDATE pedido p SET data_modificacao = CURRENT_TIMESTAMP
    WHERE p.cod_pedido = cod_pedido;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_ad_item_pedido');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_criar_pedido(
    OUT cod_pedido INT,
    IN cod_cliente INT
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO pedido(cod_cliente) VALUES (cod_cliente);
    -- Obtém o último valor gerado por serial
    SELECT LASTVAL() INTO cod_pedido;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_criar_pedido');
END;
$$;

CREATE OR REPLACE PROCEDURE sp_cadastrar_cliente(
    IN nome VARCHAR(200),
    IN codigo INT DEFAULT NULL
) LANGUAGE plpgsql AS $$
BEGIN 
    IF codigo IS NULL THEN
        INSERT INTO tb_cliente(nome) VALUES (nome);
    ELSE
        INSERT INTO tb_cliente(codigo, nome) VALUES(codigo, nome);
    END IF;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_cadastrar_cliente');
END;
$$;






-- DO $$
-- DECLARE
-- 	v_troco INT;
-- 	v_valor_pago_cliente INT := 100;
-- 	v_valor_total INT;
-- BEGIN
-- 	CALL sp_calcular_valor_de_um_pedido(1, v_valor_total);
-- 	CALL sp_calcular_troco(
-- 		v_troco, 
-- 		v_valor_pago_cliente,
-- 		v_valor_total);
-- 	RAISE NOTICE 'A conta foi de R$% e você pagou R$%. Assim retornando R$%
-- 	de troco', v_valor_total, v_valor_pago_cliente, v_troco;
-- END;
-- $$

-- -- CREATE OR REPLACE PROCEDURE sp_obter_notas_para_compor_o_troco(
-- -- 	OUT p_resultado VARCHAR(500),
-- -- 	IN p_troco INT
-- -- ) LANGUAGE plpgsql AS $$
-- -- DECLARE
-- -- 	v_notas200 INT := 0;
-- -- 	v_notas100 INT := 0;
-- -- 	v_notas50 INT := 0;
-- -- 	v_notas20 INT := 0;
-- -- 	v_notas10 INT := 0;
-- -- 	v_notas5 INT := 0;
-- -- 	v_notas2 INT := 0;
-- -- 	v_moedas1 INT := 0;
-- -- BEGIN
-- -- 	v_notas200 := p_troco / 200;
-- -- 	v_notas100 := (p_troco % 200) / 100;
-- -- 	v_notas50 := (p_troco % 200 %100) / 50;
-- -- 	v_notas20 := (p_troco %200 %100 % 50) / 20;
-- -- 	v_notas10 := (p_troco %200 %100 % 50 % 20) / 10;
-- -- 	v_notas5 := (p_troco %200 %100 % 50 % 20 % 10) / 5;
-- -- 	v_notas2 := (p_troco %200 %100 % 50 % 20 % 10 %5) / 2;
-- -- 	v_moedas1 := (p_troco %200 %100 % 50 % 20 % 10 %5 %2) / 1;
-- -- END;
-- -- $$

-- --calcular o troco
-- -- DO $$
-- -- DECLARE
-- -- 	v_troco INT;
-- -- 	v_valor_pago_cliente INT := 100;
-- -- 	v_valor_total INT;
-- -- BEGIN
-- -- 	CALL sp_calcular_valor_de_um_pedido(1, v_valor_total);
-- -- 	CALL sp_calcular_troco(
-- -- 		v_troco, 
-- -- 		v_valor_pago_cliente,
-- -- 		v_valor_total);
-- -- 	RAISE NOTICE 'A conta foi de R$% e você pagou R$%. Assim retornando R$%
-- -- 	de troco', v_valor_total, v_valor_pago_cliente, v_troco;
-- -- END;
-- -- $$


-- -- --calcular o troco
-- CREATE OR REPLACE PROCEDURE sp_calcular_troco(
-- 	OUT p_troco INT,
-- 	IN p_valor_pago_cliente INT,
@@ -52,9 +196,9 @@ $$
-- $$


-- CALL sp_fechar_pedido(19, 1);
-- CALL sp_fechar_pedido(18, 1);
-- SELECT * FROM pedido;
-- -- CALL sp_fechar_pedido(19, 1);
-- -- CALL sp_fechar_pedido(18, 1);
-- -- SELECT * FROM pedido;

-- CREATE OR REPLACE PROCEDURE sp_fechar_pedido(
-- 	IN p_valor_pago_pelo_cliente INT,
@@ -80,15 +224,15 @@ $$
-- END;
-- $$

-- DO $$
-- DECLARE
-- 	v_valor_total INT;
-- BEGIN
-- 	CALL sp_calcular_valor_de_um_pedido(1, v_valor_total);
-- 	RAISE NOTICE 'Total do pedido : % R$%', 1, v_valor_total;
-- END;
-- $$
-- -- calculo o valor total de um pedido
-- -- DO $$
-- -- DECLARE
-- -- 	v_valor_total INT;
-- -- BEGIN
-- -- 	CALL sp_calcular_valor_de_um_pedido(1, v_valor_total);
-- -- 	RAISE NOTICE 'Total do pedido : % R$%', 1, v_valor_total;
-- -- END;
-- -- $$
-- -- -- calculo o valor total de um pedido
-- CREATE OR REPLACE PROCEDURE sp_calcular_valor_de_um_pedido(
-- 	IN p_codigo_pedido INT,
-- 	OUT p_valor_total INT
@@ -120,10 +264,10 @@ $$
-- END;
-- $$

-- CALL sp_ad_item_pedido(1,1);
-- CALL sp_ad_item_pedido(3, 1);
-- SELECT * FROM tp_item_pedido;
-- SELECT * FROM pedido;
-- -- CALL sp_ad_item_pedido(1,1);
-- -- CALL sp_ad_item_pedido(3, 1);
-- -- SELECT * FROM tp_item_pedido;
-- -- SELECT * FROM pedido;

-- CREATE OR REPLACE PROCEDURE sp_criar_pedido(
-- OUT cod_pedido INT,
@@ -138,20 +282,20 @@ $$
-- END;
-- $$

-- DO $$
-- DECLARE
-- 	-- para guardar o código de pedido gerado
-- 	cod_pedido INT;
-- 	-- o código do cliente que vai fazer o pedido
-- 	cod_cliente INT;
-- BEGIN
-- 	--pegando o código da pessoa cujo se chama joão da silva
-- 	SELECT c.cod_cliente FROM tb_cliente c
-- 	WHERE nome LIKE 'João da Silva' INTO cod_cliente;
-- 	CALL sp_criar_pedido(cod_pedido, cod_cliente);
-- 	RAISE NOTICE 'Código pedido recém criado: %', cod_pedido;
-- END;
-- $$
-- -- DO $$
-- -- DECLARE
-- -- 	-- para guardar o código de pedido gerado
-- -- 	cod_pedido INT;
-- -- 	-- o código do cliente que vai fazer o pedido
-- -- 	cod_cliente INT;
-- -- BEGIN
-- -- 	--pegando o código da pessoa cujo se chama joão da silva
-- -- 	SELECT c.cod_cliente FROM tb_cliente c
-- -- 	WHERE nome LIKE 'João da Silva' INTO cod_cliente;
-- -- 	CALL sp_criar_pedido(cod_pedido, cod_cliente);
-- -- 	RAISE NOTICE 'Código pedido recém criado: %', cod_pedido;
-- -- END;
-- -- $$

-- CREATE OR REPLACE PROCEDURE sp_cadastrar_cliente(
-- 	IN nome VARCHAR(200),
@@ -168,7 +312,8 @@ $$
-- 	$$
-- CALL sp_cadastrar_cliente('João da Silva');
-- CALL sp_cadastrar_cliente('Maria Santos');
-- SISTEMA restaurante

-- --SISTEMA restaurante
-- CREATE TABLE tb_cliente(
-- 	cod_cliente SERIAL PRIMARY KEY,
-- 	nome VARCHAR(200) NOT NULL