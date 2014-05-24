function max (a,b)
  local max = 0;	
  if (max<b) then
    max = b;
  else
  	max = a;
  end
  return max
end

a = max(1, 2)