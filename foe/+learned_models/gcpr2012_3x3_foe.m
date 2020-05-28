%% CVPR_3X3_FOE - Our learned 3x3 FoE as described in the paper
%
%  Uwe Schmidt, Qi Gao, Stefan Roth.
%  A Generative Perspective on MRFs in Low-Level Vision.
%  IEEE Conference on Computer Vision and Pattern Recognition (CVPR'10), San Francisco, USA, June 2010.

% Copyright 2010 TU Darmstadt, Darmstadt, Germany.
% $Id: cvpr_3x3_foe.m 230 2010-07-07 11:09:46Z uschmidt $

function mrf = gcpr2012_3x3_foe
J = [0.2482596  -0.2033060   0.1781102   0.2433564   0.0283177   0.0008232  -0.3565564  -0.0007118
    0.1881427  -0.1560995  -0.3364888  -0.5213442   0.1173938  -0.0001166   0.5931004   0.0037785
    0.2587514   0.3567585   0.1791355   0.2750021  -0.4253688   0.0023625  -0.2537249  -0.0025540
    -0.4968594   0.5069083  -0.3381471   0.1725483   0.4046821   0.0007417   0.1539627   0.0012732
    -0.3356797   0.0996668   0.6437436  -0.3354083   0.1978831   0.0032100  -0.0796732   0.7062144
    -0.5553687  -0.6074675  -0.3469639   0.1690241  -0.1251662   0.7057445  -0.0665712  -0.7079616
    0.2398456  -0.3115292   0.1767524   0.2786379  -0.4352213  -0.0008998   0.2112901  -0.0008865
    0.1634316   0.0470077  -0.3334116  -0.5315240  -0.3103701  -0.0034200  -0.5235415   0.0041247
    0.2894769   0.2680609   0.1772696   0.2497079   0.5478495  -0.7084455   0.3217141  -0.0032769];
J = reshape(J, 9,8);


gsm = pml.distributions.gsm;
gsm.precision = 0.002;
gsm.scales = exp([-9,-7,-5:5,7,9]);
experts = repmat({gsm}, 1, 8);

W = [ 0.7732890   0.6356320   0.3424219   0.7453864   0.1993002   0.8211877   0.6820046   0.7968950
    0.0880397   0.1131191   0.2438833   0.0944571   0.2125655   0.0637325   0.0959050   0.0678788
    0.0510237   0.0685740   0.0970680   0.0559507   0.2460967   0.0457609   0.0609344   0.0497473
    0.0383443   0.0606715   0.0804852   0.0434390   0.2089829   0.0353310   0.0544919   0.0401324
    0.0439910   0.1168107   0.1993300   0.0553533   0.1312019   0.0305804   0.1022836   0.0418060
    0.0002421   0.0002957   0.0007733   0.0002496   0.0001880   0.0001384   0.0002584   0.0001447
    0.0002686   0.0003118   0.0008617   0.0002800   0.0001888   0.0001459   0.0002689   0.0001565
    0.0003988   0.0003743   0.0012349   0.0004312   0.0001924   0.0001863   0.0003118   0.0002137
    0.0010452   0.0005919   0.0036666   0.0012669   0.0001940   0.0003557   0.0004654   0.0004804
    0.0016287   0.0011846   0.0231639   0.0015370   0.0001806   0.0009596   0.0009223   0.0013927
    0.0006209   0.0010576   0.0023194   0.0004948   0.0001638   0.0009631   0.0009266   0.0006529
    0.0004225   0.0005230   0.0006951   0.0003466   0.0001712   0.0003441   0.0004392   0.0002081
    0.0003840   0.0002981   0.0004309   0.0004580   0.0002118   0.0000782   0.0002530   0.0000667
    0.0001879   0.0003063   0.0026303   0.0002836   0.0001958   0.0000071   0.0003167   0.0000084
    0.0001137   0.0002495   0.0010354   0.0000658   0.0001662   0.0002290   0.0002180   0.0002165];
W = reshape(W, 8, 15);

for i=1:8
    experts{i}.weights = W(i,:)';
end
mrf = pml.distributions.gsm_foe;
mrf = mrf.set_filter(eye(9), J, [3 3]);
mrf.experts = experts;
end
