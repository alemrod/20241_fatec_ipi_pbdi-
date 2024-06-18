-- 1.4 Procedimento com parâmetro INOUT
CREATE OR REPLACE PROCEDURE sp_contar_pedidos_cliente_inout(
    INOUT p_cod_cliente INT
) LANGUAGE plpgsql AS $$
BEGIN
    SELECT COUNT(*) INTO p_cod_cliente
    FROM pedido
    WHERE cod_cliente = p_cod_cliente;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_contar_pedidos_cliente_inout');
END;
$$;