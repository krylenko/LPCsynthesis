Linear predictive coding speech synthesis
=======================================

**************** LPCSR project code *************************

Speech analysis and synthesis using linear predictive coding 
(LPC) in Matlab. Also includes a naive speech recognition 
script using LPC functions.

*************************************************************

LPCSR_AddOverlap.m              function: combine synthesis output frames

LPCSR_Analysis.m                function: estimate LPC parameters from input
                                audio frame ("transmitter")

LPCSR_Autocorr.m                function: estimate pitch and decide whether
                                a frame is voiced or unvoiced

LPCSR_DecodeParams.m            function: convert line spectral pair (LSP)
                                parameter representation to LPC coefficients

LPCSR_EncodeParams.m            function: convert LPC coeffs to LSP format

LPCSR_ExampleRecognition.m      script: example of simple speech recognition
                                based on LPC analysis of input audio
                                
LPCSR_ExampleSynthesis.m        script: example of analysis and resynthesis 
                                of an input audio file using LPC
                                
LPCSR_Excite.m                  function: generate excitation frame from 
                                pitch and voiced/unvoiced parameters
                                
LPCSR_LoopWrapper.m             function: recordkeeping to handle iteration
                                across an input file
                                
LPCSR_NoisyTransmit.m           function: simple simulation of noisy
                                transmission channel from "transmitter" to
                                "receiver"
                                
LPCSR_PlotAnalysis.m            function: generate plots of input, analysis,
                                synthesis, and output data
                                
LPCSR_Prefilter.m               function: pre-analysis filtering of input audio

LPCSR_ProcessSamples.m          function: calculate LPC coefficients for samples
                                in a database

LPCSR_Prony.m                   function: estimate LPC filter coefficients and
                                gain from an input frame of audio data

LPCSR_Recognize.m               function: wrapper to perform speech recognition

LPCSR_Synthesis.m               function: synthesize speech based on input LPC
                                parameters ("receiver")
                                
README.txt                      this file