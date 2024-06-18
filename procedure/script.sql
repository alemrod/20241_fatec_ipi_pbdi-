--1.2 Procedimento para contar pedidos de um cliente com RAISE NOTICE
CREATE OR REPLACE PROCEDURE sp_contar_pedidos_cliente(
    IN p_cod_cliente INT
) LANGUAGE plpgsql AS $$
DECLARE
    v_total_pedidos INT;
BEGIN
    SELECT COUNT(*) INTO v_total_pedidos
    FROM pedido
    WHERE cod_cliente = p_cod_cliente;

    RAISE NOTICE 'Total de pedidos do cliente %: %', p_cod_cliente, v_total_pedidos;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_contar_pedidos_cliente');
END;
$$;