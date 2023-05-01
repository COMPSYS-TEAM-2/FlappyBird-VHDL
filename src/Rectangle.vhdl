library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

package Rectangle is

    type T_RECT is record
        X : std_logic_vector(10 downto 0);
        Y : std_logic_vector(9 downto 0);
        WIDTH : std_logic_vector(9 downto 0);
        HEIGHT : std_logic_vector(9 downto 0);
    end record T_RECT;

    -- function CreateEntity (
    --     I_X : in integer;
    --     I_Y : in integer;
    --     I_WIDTH : in integer;
    --     I_HEIGHT : in integer
    -- ) return std_logic;

    -- function CheckCollision (
    --     I_ENTITY_A : in T_ENTITY;
    --     I_ENTITY_B : in T_ENTITY
    -- ) return std_logic;

end package Rectangle;

package body Rectangle is

    function CreateEntity (
        I_X : in integer;
        I_Y : in integer;
        I_WIDTH : in integer;
        I_HEIGHT : in integer
    ) return T_RECT is
        variable L_ENTITY : T_RECT;
    begin
        L_ENTITY.X := CONV_STD_LOGIC_VECTOR(I_X, 10);
        L_ENTITY.Y := CONV_STD_LOGIC_VECTOR(I_Y, 9);
        L_ENTITY.WIDTH := CONV_STD_LOGIC_VECTOR(I_WIDTH, 9);
        L_ENTITY.HEIGHT := CONV_STD_LOGIC_VECTOR(I_HEIGHT, 9);
        return L_ENTITY;
    end;

    function CheckCollision (
        I_ENTITY_A : in T_RECT;
        I_ENTITY_B : in T_RECT
    ) return std_logic is
    begin
        return (((I_ENTITY_A.X + I_ENTITY_A.WIDTH) >= I_ENTITY_B.X) and
        ((I_ENTITY_B.X + I_ENTITY_B.WIDTH) >= I_ENTITY_A.X) and
        ((I_ENTITY_A.Y + I_ENTITY_A.HEIGHT) >= I_ENTITY_B.Y) and
        ((I_ENTITY_B.Y + I_ENTITY_B.HEIGHT) >= I_ENTITY_A.Y));
    end;

end package body Rectangle;