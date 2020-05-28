%% CVPR_3X3_FOE - Our learned 3x3 FoE as described in the paper
%
%  Uwe Schmidt, Qi Gao, Stefan Roth.
%  A Generative Perspective on MRFs in Low-Level Vision.
%  IEEE Conference on Computer Vision and Pattern Recognition (CVPR'10), San Francisco, USA, June 2010.

% Copyright 2010 TU Darmstadt, Darmstadt, Germany.
% $Id: cvpr_3x3_foe.m 230 2010-07-07 11:09:46Z uschmidt $

function mrf = gcpr2012_3x3_foe
J = [0.0814784   0.1148881   0.0344712   0.0266946   0.0613626  -0.0124018  -0.0184927  -0.1111943  -0.0350455   0.0102771  -0.0237363   0.0107928   0.0286492   0.0006982  -0.0745518   0.0048355
  -0.2352611   0.1223260  -0.1642142  -0.0794059  -0.1766914   0.0061871   0.0094146  -0.5388024  -0.1417558   0.1605693   0.0173212   0.0016012   0.1899719   0.0026208   0.2244541   0.0060236
   0.3090759   0.0084454  -0.0584595   0.1049265   0.2139866   0.0146513   0.0672981  -0.2119617  -0.1077883  -0.2160800   0.0254729  -0.0034851   0.3978184  -0.1255956  -0.3182146  -0.0029894
  -0.2318818  -0.1246265   0.1881434  -0.0765561  -0.1588504   0.0019062  -0.0330610  -0.0052613  -0.0426522  -0.0684252  -0.0216868   0.0201071   0.2786971   0.0114677   0.2519682  -0.0012648
   0.0819841  -0.1132054  -0.0080720   0.0252828   0.0547649  -0.0045843  -0.0195491   0.0070956  -0.0152606   0.0895364  -0.0008744  -0.0237981   0.0581545   0.1252127  -0.0879439  -0.0068570
  -0.0596930  -0.3233360   0.1423947  -0.0859389   0.1055245  -0.0965621  -0.0332672  -0.0616126   0.1466563   0.0599432   0.1564581  -0.0079322   0.0084783   0.0021511   0.0782252  -0.0017925
   0.1726533  -0.3244498   0.1501711   0.2428265  -0.2667464  -0.0377604  -0.0680296  -0.3253501   0.3658410  -0.1062058  -0.1442546  -0.0378444   0.0384965  -0.0032385  -0.2375345   0.0481350
  -0.2323647  -0.0470105  -0.4398570  -0.3156276   0.3341313   0.1398025   0.2652008  -0.1792554   0.3257109  -0.3886287  -0.1651847  -0.0004811  -0.1567093   0.3606792   0.3279868  -0.0233196
   0.1763947   0.3234904  -0.0257349   0.2369064  -0.2616876   0.0530449  -0.2192530   0.0055924   0.1488536   0.4456210   0.1757374   0.0112520  -0.2878148  -0.0403477  -0.2535462  -0.0225519
  -0.0603373   0.3182001   0.1398362  -0.0814423   0.0944213  -0.0555466   0.0506554  -0.0088953   0.0843556   0.0014779  -0.0149452   0.0350512  -0.1496717  -0.3609598   0.0870139   0.0175308
  -0.1107576   0.3338476  -0.1158568   0.1195258   0.1390187  -0.3411290   0.0749652   0.1306430  -0.1912891  -0.0340088  -0.3128262  -0.0834282  -0.0050685   0.0013127   0.0621597  -0.0391877
   0.3023369   0.3337135   0.4037224  -0.3364742  -0.3760249   0.0777153  -0.3995780   0.5639727  -0.4199793  -0.3080300   0.2897202  -0.3764742  -0.1666402   0.0027574  -0.1933716   0.0468812
  -0.3883722   0.0681889   0.1409491   0.4393736   0.4698457   0.4235226   0.6469404   0.2605762  -0.4174240   0.4487941   0.3385869  -0.0302565  -0.4069166  -0.4703120   0.2797696   0.4340495
   0.2953583  -0.3311056  -0.4214398  -0.3300678  -0.3703997   0.1368549  -0.3969086   0.0069327  -0.2235174   0.1088390  -0.3670777   0.2100817  -0.3343853   0.0317541  -0.2371615   0.1449859
  -0.1073540  -0.3235123   0.0046920   0.1133435   0.1395278  -0.3031603   0.0763333   0.0032962  -0.1310427  -0.2085608   0.0386774   0.3014103  -0.0566259   0.4646847   0.0910151   0.0229440
  -0.0186783  -0.1428331  -0.1177056  -0.0937292   0.0450612  -0.3295274   0.0462745   0.0638795   0.1104089  -0.0654943   0.2987762  -0.0250996  -0.0411755  -0.0037868  -0.0805289  -0.0248849
   0.0460103  -0.1430650  -0.1619493   0.2614259  -0.1338972   0.1589352  -0.2050009   0.3025126   0.2733060   0.1230511  -0.2695639  -0.5233205  -0.1640890  -0.0005982   0.2589636  -0.4169295
  -0.0522799  -0.0405513   0.4266013  -0.3427170   0.1840840   0.4797681   0.2543522   0.1070209   0.2900693   0.2473710  -0.3318538  -0.1504714  -0.1777121   0.3507547  -0.3812905  -0.6497709
   0.0368309   0.1448189   0.0295969   0.2600822  -0.1514353  -0.0211399  -0.0749870  -0.0072537   0.1602369  -0.3123372   0.3540932   0.0602066   0.0676287  -0.0034090   0.3137303  -0.1349501
  -0.0126044   0.1388072  -0.1529142  -0.0907230   0.0601656  -0.2979087  -0.0270390   0.0011283   0.0760823   0.0206984  -0.0370054   0.6154022   0.0681232  -0.3426704  -0.1128225  -0.0346262
   0.1024917   0.0173189   0.0338594   0.0325338  -0.0098506  -0.1173154  -0.0200270  -0.0051545  -0.0276026   0.0210332  -0.1163193   0.0117728   0.0076949   0.0016948   0.0118895   0.0584278
  -0.2799626   0.0094111  -0.1593432  -0.0919461   0.0036583   0.1124817  -0.0267170  -0.0063280  -0.0846168   0.0550231   0.1047630  -0.0780753   0.0978342   0.0010569  -0.0478742   0.3213848
   0.3581430   0.0107486  -0.0413605   0.1217830   0.0210165   0.2091243   0.0502903   0.0115991  -0.0850418  -0.0264103   0.1316895  -0.0937368   0.3469956  -0.1191459   0.0858521   0.2442436
  -0.2706418  -0.0125367   0.1671112  -0.0924753  -0.0237737  -0.0344781   0.0203878   0.0023279  -0.0464680  -0.1095855  -0.1437989   0.0300223   0.2801264  -0.0031989  -0.0715213   0.0101800
   0.0974314  -0.0179726   0.0053581   0.0323988   0.0027882  -0.1624801  -0.0202024  -0.0055076  -0.0120366   0.0515317   0.0178313   0.1267032   0.0781401   0.1164178   0.0233336  -0.0004971];
J = reshape(J, 25,16);


gsm = pml.distributions.gsm;
gsm.precision = 0.002;
gsm.scales = exp([-9,-7,-5:5,7,9]);
experts = repmat({gsm}, 1, 16);

W = [ 0.6606311   0.8258002   0.9133571   0.2936597   0.8699843   0.9722660   0.8785988   0.9489186   0.8802097   0.8679259   0.7451739   0.9551607   0.9550963   0.6197690   0.5194311   0.9351258
   0.0841703   0.0449611   0.0338302   0.1955125   0.0393061   0.0134829   0.0481199   0.0246208   0.0417920   0.0469688   0.0632184   0.0169668   0.0189224   0.0984935   0.0999539   0.0250412
   0.0690446   0.0477423   0.0275450   0.1031191   0.0371203   0.0090980   0.0368126   0.0145551   0.0359222   0.0386922   0.0588644   0.0142177   0.0152538   0.0726579   0.0882548   0.0221796
   0.0697549   0.0445450   0.0161857   0.0981830   0.0300530   0.0035366   0.0229099   0.0065452   0.0256767   0.0278041   0.0590221   0.0073748   0.0072678   0.0718987   0.0971007   0.0121910
   0.1129062   0.0358046   0.0073313   0.2955957   0.0224269   0.0012582   0.0112779   0.0042771   0.0148699   0.0159366   0.0717892   0.0057785   0.0029685   0.1321094   0.1929437   0.0045430
   0.0001724   0.0000885   0.0000677   0.0003869   0.0000791   0.0000231   0.0000950   0.0000489   0.0000786   0.0000935   0.0001335   0.0000313   0.0000346   0.0001999   0.0001853   0.0000473
   0.0001785   0.0000908   0.0000716   0.0004055   0.0000840   0.0000239   0.0001001   0.0000625   0.0000815   0.0000963   0.0001372   0.0000370   0.0000365   0.0002078   0.0001900   0.0000477
   0.0002119   0.0001041   0.0001003   0.0004874   0.0001106   0.0000282   0.0001379   0.0001220   0.0001032   0.0001232   0.0001557   0.0000587   0.0000437   0.0002506   0.0002094   0.0000560
   0.0003962   0.0001532   0.0003066   0.0008999   0.0002178   0.0000339   0.0003638   0.0003858   0.0002110   0.0002967   0.0002399   0.0001406   0.0000542   0.0004883   0.0002813   0.0000892
   0.0017752   0.0002509   0.0008777   0.0083214   0.0002981   0.0000343   0.0009275   0.0002647   0.0005808   0.0015040   0.0005942   0.0001313   0.0000564   0.0029124   0.0004772   0.0001757
   0.0003611   0.0001976   0.0001563   0.0016791   0.0001150   0.0000337   0.0002923   0.0000850   0.0002703   0.0003308   0.0003004   0.0000376   0.0000571   0.0006023   0.0003285   0.0002316
   0.0000893   0.0001064   0.0000751   0.0002121   0.0000570   0.0000433   0.0001881   0.0000401   0.0000997   0.0001170   0.0000802   0.0000164   0.0000726   0.0001335   0.0001112   0.0001924
   0.0000504   0.0000547   0.0000448   0.0000913   0.0000388   0.0000987   0.0001314   0.0000256   0.0000390   0.0000528   0.0000427   0.0000105   0.0000944   0.0000638   0.0000604   0.0000499
   0.0000962   0.0000196   0.0000174   0.0012974   0.0000505   0.0000238   0.0000242   0.0000133   0.0000165   0.0000168   0.0001194   0.0000074   0.0000248   0.0000731   0.0002942   0.0000078
   0.0001616   0.0000809   0.0000333   0.0001491   0.0000586   0.0000154   0.0000208   0.0000353   0.0000487   0.0000411   0.0001289   0.0000307   0.0000169   0.0001395   0.0001782   0.0000218];
W = reshape(W, 16, 15);

for i=1:16
    experts{i}.weights = W(i,:)';
end
mrf = pml.distributions.gsm_foe;
mrf = mrf.set_filter(eye(25), J, [5 5]);
mrf.experts = experts;
end
