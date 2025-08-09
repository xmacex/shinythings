---shiny things!
--
-- → 1 signal 1
-- → 2 signal 2
--   1 signal 1 integral  →
--   2 signal 1 derivate  →
--   3 signal 2 integral  →
--   4 signal 2 derivate  →
--
-- by xmacex

local MINV = -5
local MAXV = 10

local TRUEV  = 5
local FALSEV = 0

local FREQ   = 444

local integrals = {0, 0}
local derivates = {0, 0}
local dt        = 1/FREQ

public{i_bend = {7, 7}}:range(0, 12)
public{d_div  = {10, 10}}:range(1, 100)

function init()
   output[1].slew = 1/FREQ
   input[1].mode("stream", dt)
   input[1].stream = process1

   output[3].slew = 1/FREQ
   input[2].mode("stream", dt)
   input[2].stream = process2
end

function process1(v)
   local dv = integrate(v, dt)*math.exp(public.i_bend[1])
   integrals[1] = clamp(integrals[1]+dv, MINV, MAXV)
   derivates[1] = derivate(integrals[1], output[1].volts, dt)

   output[1].volts = integrals[1]
   output[2].volts = derivates[1] / public.d_div[1]
end

function process2(v)
   local dv = integrate(v, dt)*math.exp(public.i_bend[2])
   integrals[2] = clamp(integrals[2]+dv, MINV, MAXV)
   derivates[2] = derivate(integrals[2], output[3].volts, dt)

   output[3].volts = integrals[2]
   output[4].volts = derivates[2] / public.d_div[2]
end

function integrate(v, dt)
   return v/(1/dt)
end

function derivate(v, v_, dt)
   return (v - v_)/dt
end

function clamp(v, min, max)
   return math.max(min, math.min(v, max))
end

-- Local Variables:
-- flycheck-luacheck-standards: ("crow")
-- End:
