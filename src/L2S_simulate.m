function L2S_simulate(L2SStruct,parameters)

global c_sim;

simNum = 1;

for chMult = 1:length(L2SStruct.chan_multipath)
    
    for ver = 1:length(L2SStruct.version)
        
        c_sim.version = L2SStruct.version{ver};
        
        for wChan = L2SStruct.w_channel
            
            c_sim.w_channel = wChan;
            
            for cyPre = 1:length(L2SStruct.cyclic_prefix)
                
                c_sim.cyclic_prefix = ...
                    L2SStruct.cyclic_prefix{cyPre};
                
                for data_len = L2SStruct.data_len
                    
                    c_sim.data_len = data_len;
                    
                    if L2SStruct.display
                        disp(['Channel model: '...
                            L2SStruct.chan_multipath{chMult}]);
                        disp(['Standard: '...
                            L2SStruct.version{ver}]);
                        disp(['Bandwidth: ' num2str(wChan)]);
                        disp(['Cyclic prefix: '...
                            L2SStruct.cyclic_prefix{cyPre}]);
                        disp(['Data length: ' num2str(data_len)]);
                        disp('Simulating AWGN...');
                    end
                    
                    c_sim.chan_multipath = 'off';
                    
                    [perAWGN_mtx,~,~] = hsr_sim(parameters);
                    
                    c_sim.chan_multipath = L2SStruct.chan_multipath{chMult};
                    
                    for numChannRea = 1:L2SStruct.maxChannRea
                        
                        if L2SStruct.display
                            disp('Simulating with multipath');
                            disp(['Channel realization: '...
                                num2str(numChannRea)]);
                        end
                        
                        c_sim.rnd_state = L2SStruct.seeds(numChannRea);
                        
                        [per,~,C_channel] = hsr_sim(parameters);
                        SNRp = L2S_SNRp(c_sim,C_channel);
                        
                        filename = [L2SStruct.folderName '\L2S_results_' num2str(simNum) '.mat'];
                        save(filename,'L2SStruct','c_sim','SNRp','per','perAWGN_mtx');
                        simNum = simNum + 1;
                        
                    end % SNRps loop
                    
                end % data_len loop
                
            end % cyclic_prefix loop
            
        end % w_channel loop
        
    end % version loop
    
end % chan_multipath loop

end