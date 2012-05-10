function points = generate_users(users, radius)
%generate_users(users, radius) returns a number of points within a radius

points = ones(users, 2) * radius;

for i = 1:users
    while ((points(i,1)^2 + points(i,2)^2)>radius^2)
        points(i,:) = randi([-radius radius], 1, 2);
    end
    
end
end