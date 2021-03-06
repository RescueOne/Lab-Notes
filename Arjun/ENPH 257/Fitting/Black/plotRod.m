%function to easily plot heating data
function plotRod( timeData, T1, T2, T3, T4, Tamb, timeSim, T1Sim, T2Sim, T3Sim, T4Sim );
	
	%check to make sure the size of timeData and points are the same
	if( size(timeData, 2) > size(T1, 2) )
		timeData = timeData(1:size(T1, 2));
	end

	%plot dots for data points
	plot(timeData, 	T1, 		'c.', ... %Data
		 timeSim,	T1Sim, 		 ... %Simulation
		 timeData, 	T2, 		'g.', ... %Data 
		 timeSim, 	T2Sim, 		 ... %Simulation
		 timeData,	T3, 		'b.', ... %Data
		 timeSim,	T3Sim, 		 ... %Simulation
		 timeData, 	T4, 		'r.', ... %Data
		 timeSim, 	T4Sim, 		 ... %Simulation
		 timeData, 	Tamb,		'm.', ... %Data, no simulation for ambient temps
		 'Markersize', 7, 'Linewidth', 1.5)

	xlabel('Time (seconds)', 'Fontsize', 14);
	ylabel('Temperature (Celsius)', 'Fontsize', 14);

	legendLabels = {'Data: 0mm (Cool End)', ...
					'Simulation: 0mm (Cool End)', ...
					'Data: 10mm', ...
					'Simulation: 10mm', ...
					'Data: 20mm', ...
					'Simulation: 20mm', ...
					'Data: 30mm (Hot End)',...
					'Simulation: 30mm (Hot End)',...
					'Ambient Temperature'};

	legend(legendLabels , 'Location', 'NorthWest', 'Fontsize', 12);
	grid on
	axis([0 inf 20 70]);
	title({'Black Painted Horizonatal Rod Heating', 'Temperature vs. Time at Various Positions'}, 'Fontsize', 16);
end