% adjusts velocities due to wall collision (rdot,which molecule collides
% with wall, dimension of collision, which iteration we are on)

function[rdot_final,pressure_final] = harddisks_wall_collision(rdot,j,dimension,i,pressure)

rdot(:,:,i+1)=rdot(:,:,i); % update velocities

if dimension==1
    rdot(j,1,i+1)=-rdot(j,1,i); % flip x velocity of jth particle
    pressure(i+1)=abs(rdot(j,1,i)); % update pressure vector with change in momentum during ith iteration
else
    rdot(j,2,i+1)=-rdot(j,2,i); % flip y velocity of jth particle
    pressure(i+1)=abs(rdot(j,2,i)); % update pressure vector with change in momentum during ith iteration
end

rdot_final=rdot; % return rdot
pressure_final=pressure; % return pressure

end