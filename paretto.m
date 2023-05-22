function y = paretto(data)

[m,n] = size(data); idx = 1:m;
for i=1:n
    idx = find(data(idx,i)==max(data(idx,i)));
    if numel(idx)==1, break; end
end

y = max([data(idx,:);zeros(1,n)]);
if ~any(y)
    y = [1 1 1];
end

end

