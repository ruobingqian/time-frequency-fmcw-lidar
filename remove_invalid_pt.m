%%This function removes the invalid pts in each sweep of the insight laser.
%%These indexs below were provided by the insight laser SW and should be
%%fixed for every sweep 

function output = remove_invalid_pt(input)
%invalid pts of insight laser sweep
pts = [840:855 1492:1507 2170:2185 2806:2821 3420:3437 4078:4093 4730:4745 5410:5425 6040:6055 6664:6681 7290:7305 7970:7985 8624:8639 9312:9327 9856:9873 10510:10525 11186:11201 11844:11859 12526:12541 13180:13197 13936:13951 14616:14631 15276:15291 15958:15973 16618:16635 17344:17359 18030:18045 18710:18725 19366:19381 20022:20039 20736:20751 21418:21433 22126:22141 22784:22799 23508:23525 24320:24335 25096:25157 26040:26055 26916:26931 27578:27595 28354:28369 29250:29265 30142:30157 30754:30771 31602:31617 32494:32509 33370:33385 34004:34021 34798:34813 35694:35709 36564:36579 37208:37225 38024:38039 38902:38917 39768:39783 40524:40541 41442:41457 42318:42333 43228:43243 43944:43961 44818:44833 45708:45723 46542:46557 47262:47287 48196:48211]-57; 
sz = size(pts);
for i = 1:sz(2)
    input(pts(i))=0;
end
output=input(input~=0);
end