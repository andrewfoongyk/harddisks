% Event driven hard disks molecular dynamics simulation
close;

% Constants
x_size=1; % size of box
y_size=1;
N=5^2; % number of disks - use a perfect square
radius=0.01; % radius of disks
I=500; % number of iterations
dt=0.03; % timestep for playback

r=zeros(N,2,I); 
rdot=zeros(N,2,I); 

% create square grid of starting positions
r(:,1,1)=0.5*repmat(transpose(1/(sqrt(N)+1)*linspace(1,sqrt(N),sqrt(N))),sqrt(N),1); 
r(:,2,1)=1/(sqrt(N)+1)*ceil(linspace(0,N,N)/sqrt(N));
r(1,2,1)=1/(sqrt(N)+1);
% set equal magnitude but random direction initial velocities
s=1; % initial speed
randv=2*pi*rand(N,1); % random directions and constant magnitude
for n=1:N
rdot(n,1,1)=s*cos(randv(n));
rdot(n,2,1)=s*sin(randv(n));
end

t=zeros(I+1,1); % timer variable
pressure=zeros(I+1,1); % pressure counter variable

for i=1:I % for I iterations
    [twall,j,dimension]=harddisks_wall_collision_time(r,rdot,radius,x_size,y_size,i); % jth particle next to wall
    [tpair,k,l]=harddisks_pair_collision_time(r,rdot,radius,i); % k & lth particle next to pair collide
    tnext=min(twall,tpair); % time to next event
    
    % update
    t(i+1)=t(i)+tnext; % update time array
    r(:,:,i+1)=r(:,:,i)+tnext*rdot(:,:,i); % update position array
    
    % update velocity array
    
    if twall<tpair
        [rdot,pressure]=harddisks_wall_collision(rdot,j,dimension,i,pressure);
    else
        [rdot]=harddisks_pair_collision(rdot,r,k,l,i);
    end
    
    display(i);
 
end

% Plot results
scale=0.2; % arrow lengths

% create time based matrices
tsteps=floor(t(I+1)/dt); % number of timesteps
r_time=zeros(N,2,tsteps);
rdot_time=zeros(N,2,tsteps);
for j=1:tsteps
    % find the correct entry i to refer to
    f=find(sign(t-j*dt)+1);
    i=f(1)-1;
    rdot_time(:,:,j)=rdot(:,:,i);
    r_time(:,:,j)=r(:,:,i)+rdot(:,:,i)*(j*dt-t(i)); % update positions smoothly
end

display('press any key to play slideshow');
pause;

% play velocity histogram slideshow

bins=20;
hsum=zeros(1,bins-1);
for j=1:tsteps % for each iteration recorded
    clf;
    Xhist=linspace(-3,3,20);
    histogram(rdot_time(:,1,j),Xhist);
    if j>tsteps/2 %only calculate average histogram after half the simulation time has elapsed
        hsum=hsum+histcounts(rdot_time(:,1,j),Xhist);
    end
    pause(dt); % pause
end
% overlay plot of time averaged histogram
hold on;
plot(linspace(-3,3,bins-1),2*hsum/tsteps);

pause;


%calculate time avg histogram for velocity
%{
bins=20;
Xhist=linspace(-3,3,20);
countsv=zeros(1,bins);
totalhist=zeros(1);
for j=1:tsteps % for each iteration recorded
    countsv=countsv+hist(rdot_time(:,1,j),Xhist);
    for n=1:N
        totalhist=[totalhist,rdot_time(n,1,j)];
    end
end
% overlay plot of time averaged histogram
hold on;
plot(Xhist,countsv/tsteps);
%}

% play speed histogram slideshow
%{
bins=20;
speed=sqrt(sum((rdot_time.*rdot_time),2));
hsum=zeros(1,bins-1);
Xhist=linspace(0,3,bins);
for j=1:tsteps % for each iteration recorded
    clf;
    histogram(speed(:,1,j),Xhist);
    if j>tsteps/2 %only calculate average histogram after half the simulation time has elapsed
        hsum=hsum+histcounts(speed(:,1,j),Xhist);
    end
    pause(dt); % pause
end
% overlay plot of time averaged histogram
hold on;
plot(linspace(0,3,bins-1),2*hsum/tsteps);

pause;
%}

%calculate time avg speed histogram by summing histogram vectors
%{
bins=20;
speed=sqrt(sum((rdot_time.*rdot_time),2));
Xhist=linspace(0,3,bins);
counts=zeros(1,20);
totalhistspeed=zeros(1);
for j=1:tsteps % for each iteration recorded
    clf;
    counts=counts+hist(speed(:,1,j),Xhist);
    for n=1:N
        totalhistspeed=[totalhistspeed,speed(n,1,j)];
    end
end
% overlay plot of time averaged histogram
hold on;
plot(Xhist,counts/tsteps);
%}

% play squared speed (energy) histogram slideshow
%{
bins=20;
speed=(sum((rdot_time.*rdot_time),2));
hsum=zeros(1,bins-1);
Xhist=linspace(0,3,bins);
for j=1:tsteps % for each iteration recorded
    clf;
    histogram(speed(:,1,j),Xhist);
    if j>tsteps/2 %only calculate average histogram after half the simulation time has elapsed
        hsum=hsum+histcounts(speed(:,1,j),Xhist);
    end
    pause(dt); % pause
end
% overlay plot of time averaged histogram
hold on;
plot(linspace(0,3,bins-1),2*hsum/tsteps);

pause;
%}

% calculate time avg energy histogram
%{
bins=20;
speed=(sum((rdot_time.*rdot_time),2));
Xhist=linspace(0,5,bins);
countsE=zeros(1,bins);
totalhistE=zeros(1);
for j=1:tsteps % for each iteration recorded
    countsE=countsE+hist(speed(:,1,j),Xhist);
    for n=1:N
        totalhistE=[totalhistE,speed(n,1,j)];
    end
end
% overlay plot of time averaged histogram
hold on;
plot(Xhist,countsE/tsteps);
%}

% play video slideshow
for i=1:tsteps % for each iteration recorded
clf;
hold on; 
axis([0,x_size,0,y_size]); % set axes to fit 'box'
axis square;
viscircles(r_time(:,:,i),ones(N,1)*radius); % plot particle positions
quiver(r_time(:,1,i),r_time(:,2,i),rdot_time(:,1,i),rdot_time(:,2,i),scale); % plot velocity vectors
pause(dt); % pause
end

% play velocity space slideshow
%{
% determine limits of velocity space
rdotmax=abs(max(rdot_time));
for i=1:tsteps
    clf;
    hold on; 
    axis([-2,2,-2,2]); % set axes to fit velocity space
    axis square;
    scatter(rdot_time(:,1,i),rdot_time(:,2,i),5); % plot velocity coordinate of disks
    pause(dt);
end
%}

% calculate time averaged pressure
pavg=sum(pressure)/t(I+1)
