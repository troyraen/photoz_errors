function [] = plot_specphotz(specz, photoz)
% Plots spec_z vs photo_z

figure(112)
plot(specz, photoz);
xlabel('spec_z');
ylabel('photo_z');
