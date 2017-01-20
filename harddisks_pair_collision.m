% adjusts velocities due to pair collision (rdot,r,which molecules involved 
% in collision, which iteration we are on,radius,x size,y size)

function[rdot_final] = harddisks_pair_collision(rdot,r,k,l,i)

%update velocities
rdot(:,:,i+1)=rdot(:,:,i);

%compute quantities for new velocities due to pair collision
delta_x=r(k,:,i)-r(l,:,i);
e_perp=delta_x/norm(delta_x);
delta_v=rdot(k,:,i)-rdot(l,:,i);

%update velocities
rdot(k,:,i+1)=rdot(k,:,i)-dot(delta_v,e_perp)*e_perp;
rdot(l,:,i+1)=rdot(l,:,i)+dot(delta_v,e_perp)*e_perp;
rdot_final=rdot; % return rdot

end