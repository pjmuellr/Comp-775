function normal = findnormal(point1,point2)

v = point1-point2;
v2 = sqrt((v(1)^2)+(v(2)^2));
normal = v/v2;
normal(1)=normal(1)*-1;
