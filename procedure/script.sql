-- 1.6 Blocos anônimos para executar cada procedimento
DO $$
DECLARE
    v_resultado VARCHAR(500);
BEGIN
    CALL sp_obter_notas_para_compor_o_troco(v_resultado, 587);
    RAISE NOTICE 'Resultado: %', v_resultado;
END;
$$
--
DO $$
BEGIN
    CALL sp_contar_pedidos_cliente(1);
END;
$$
---
DO $$
DECLARE
    v_total_pedidos INT;
BEGIN
    CALL sp_contar_pedidos_cliente_out(1, v_total_pedidos);
    RAISE NOTICE 'Total de pedidos: %', v_total_pedidos;
END;
$$
---
DO $$
DECLARE
    v_cod_cliente INT := 1;
BEGIN
    CALL sp_contar_pedidos_cliente_inout(v_cod_cliente);
    RAISE NOTICE 'Total de pedidos: %', v_cod_cliente;
END;
$$
---
DO $$
DECLARE
    v_mensagem TEXT;
BEGIN
    CALL sp_cadastrar_clientes_variadic(v_mensagem, 'Pedro', 'Ana', 'João');
    RAISE NOTICE '%', v_mensagem;
END;
$$
------