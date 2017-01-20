% calculates time to wall collision for all particles

function[twall,j,dimension] = harddisks_wall_collision_time(r,rdot,radius,x_size,y_size,i)

N=size(r,1); % number of particles
t=zeros(N,2); % time storage vector, with dimensions

for n=1:N % for each particle
    
    if rdot(n,1,i)>0 % if the x velocity is positive
        t1=(x_size-r(n,1,i)-radius)/rdot(n,1,i); % time to right wall collision
    elseif rdot(n,1,i)<0 % if x velocity negative
        t1=-(r(n,1,i)-radius)/rdot(n,1,i); % time to left wall collision
    else
        t1=1000000; % no collision
    end
    
    if rdot(n,2,i)>0 % if the y velocity is positive
        t2=(y_size-r(n,2,i)-radius)/rdot(n,2,i); % time to top wall collision
    elseif rdot(n,2,i)<0 % if y velocity negative
        t2=-(r(n,2,i)-radius)/rdot(n,2,i); % time to bottom wall collision
    else
        t2=1000001; % no collision 
    end
        
    t(n,1)=min(t1,t2); % wall collision time for nth particle
    
    if t1<t2 % if collision is with a vertical wall
        t(n,2)=1;
    else % if collision is with a horizontal wall
        t(n,2)=2;
    end
end

[twall,j]=min(t(:,1)); % find minimum time and particle involved
dimension=t(j,2); % dimension that needs flipping

end