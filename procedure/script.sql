-- 1.3 Procedimento para contar pedidos com variável de saída
CREATE OR REPLACE PROCEDURE sp_contar_pedidos_cliente_out(
    IN p_cod_cliente INT,
    OUT p_total_pedidos INT
) LANGUAGE plpgsql AS $$
BEGIN
    SELECT COUNT(*) INTO p_total_pedidos
    FROM pedido
    WHERE cod_cliente = p_cod_cliente;

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_contar_pedidos_cliente_out');
END;
$$;