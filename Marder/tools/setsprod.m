% My own sets product formula
function prod = setsprod(a1, a2)
  prodd = zeros(length(a1) * length(a2), length(a1(1,:)) + length(a2(1,:)));
  counter = 1;
  for i = 1:length(a1)
    for j = 1:length(a2)
      prodd(counter, :) = [a1(i,:), a2(j,:)];
      counter = counter + 1;
    end
  end
  prod = prodd;
end
