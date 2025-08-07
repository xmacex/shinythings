---shiny things!
--
-- → 1 signal 1
-- → 2 signal 2
--   1 signal 1 integral  →
--   2 signal 1 rising    →
--   3 signal 2 integral  →
--   4 signal 2 rising    →
--
-- by xmacex

local MINV = -5
local MAXV = 10

local TRUEV  = 5
local FALSEV = 0

local FREQ   = 333

local integrals = {0, 0}
local rising    = {false, false}
local dt        = 1/FREQ

public{bend1 = 7}:range(0.1, 12)
public{bend2 = 7}:range(0.1, 12)

function init()
   output[1].slew = 1/FREQ
   input[1].mode("stream", dt)
   input[1].stream = process1

   output[3].slew = 1/FREQ
   input[2].mode("stream", dt)
   input[2].stream = process2
end

function process1(v)
   -- dv = integrate(v, dt)*public.timemult
   local dv = integrate(v, dt)*math.exp(public.bend1)
   integrals[1] = clamp(integrals[1]+dv, MINV, MAXV)
   rising[1] = dv > 0

   output[1].volts = integrals[1]
   if rising[1] then output[2].volts = TRUEV else output[2].volts = FALSEV end
end

function process2(v)
   -- dv = integrate(v, dt)*public.timemult
   local dv = integrate(v, dt)*math.exp(public.bend2)
   integrals[2] = clamp(integrals[2]+dv, MINV, MAXV)
   rising[2] = dv > 0

   output[3].volts = integrals[2]
   if rising[2] then output[4].volts = TRUEV else output[4].volts = FALSEV end
end

function integrate(v, dt)
   return v/(1/dt)
end

function clamp(v, min, max)
   return math.max(min, math.min(v, max))
end


-- Local Variables:
-- flycheck-luacheck-standards: ("crow")
-- End:
