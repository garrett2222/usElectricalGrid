%Initialize Electrical grid
r01=.3;
r12=r01;
r23=r01;
r34=.5;
 
r1=5;
r2=5;
r3=8;
 
r=[r01+r1+r12, -r12, 0;-r12,r12+r2+r23,-r23;0,-r23,r23+r3+r23];
 
%Initialize Geoelectric field
minutes=10;
GICpts=10*60;
I=zeros(3,GICpts);
I_2_ground=zeros(4,GICpts);
min=0;
max=15;
magnitude(1,1)=(max-min)*rand(1,1)*100;
magnitude(2,1)=magnitude(1,1)+.05*(-1+2*rand(1,1))*magnitude(1,1);
magnitude(3,1)=magnitude(2,1)+.05*(-1+2*rand(1,1))*magnitude(2,1);
for i=2:GICpts
    magnitude(:,i)=magnitude(:,i-1)+.05*(-1+2*rand(3,1)).*magnitude(:,i-1);
end
angle(1,1)=(2*pi)*rand(1,1);
angle(2,1)=angle(1,1)+.05*(-1+2*rand(1,1))*angle(1,1);
angle(3,1)=angle(2,1)+.05*(-1+2*rand(1,1))*angle(1,1);
for i=2:GICpts
    angle(:,i)=angle(:,i-1)+.05*(-1+2*rand(3,1)).*angle(:,i-1);
end
effect=magnitude.*sin(angle);
for i=1:GICpts
    I(:,i)=r\effect(:,i);
    I_2_ground(:,i)=[-I(1,i);I(1,i)-I(2,i);I(2,i)-I(3,i);I(3,i)];
end
%More plots for visualization, not used in analysis
%{
figure
names={'I01';'I12';'I23';'I34';'I_1';'I_2';'I_3'};
for i=1:7
    if i<=4 
        name=sprintf('Current to Ground for %s',names{i});
        subplot(2,4,i)
        plot(I_2_ground(i,:))
        title(name)
        xlabel('Time (sec)')
        ylabel('Current (A)')
    end
    if i>4
        name2=sprintf('Current for %s',names{i});
        subplot(2,4,i)
        plot(I(i-4,:))
        title(name2)
        xlabel('Time (sec)')
        ylabel('Current (A)')
    end
end
%}
figure
title('Currents from Substations to Ground')
xlabel('Time (sec)')
ylabel('Current (A)')
hold on
for i=1:4
    plot(I_2_ground(i,:))
end
legend('I01','I12','I23','I34')
hold off
figure
title('Currents in Transmission Lines')
xlabel('Time (sec)')
ylabel('Current (A)')
hold on
for i=1:3
    plot(I(i,:))
end
legend('I_1','I_2','I_3')
hold off

