% calculates time to next pair collision for all pairs of particles

function[tpair,particle1,particle2] = harddisks_pair_collision_time(r,rdot,radius,i)

N=size(r,1); % number of particles
tpair=1000000; % storage variable
particle1=0; % dummy variables
particle2=0;

for k=1:N % for each particle
    for l=k+1:N % for each particle 'below'
       
        % calculate the pair collision time, storing only the lowest value
        % seen so far
        delta_x=r(k,:,i)-r(l,:,i);
        delta_v=rdot(k,:,i)-rdot(l,:,i);
        upsilon=dot(delta_x,delta_v)^2-norm(delta_v)^2*(norm(delta_x)^2-4*radius^2);
        
        if and(upsilon>0,dot(delta_x,delta_v)<0) 
            if -(dot(delta_x,delta_v)+sqrt(upsilon))/dot(delta_v,delta_v)<tpair
                particle1=k;
                particle2=l;
            end
            tpair=min(tpair,-(dot(delta_x,delta_v)+sqrt(upsilon))/dot(delta_v,delta_v));
        else
            tpair=min(tpair,1000003); % no pair collision
        end
   end

end