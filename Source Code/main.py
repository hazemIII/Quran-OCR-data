import matlab.engine
import lineSegmantationFinal
import scipy.io as sio
import secondaries
M  = matlab.engine.start_matlab()
# print "start frame extraction"
# M.main(nargout=0)
# print "end frame extraction"
for i in range(1,2,1):
    print i

    # print "start segmentation"
    # path = "D:\comm-4th year\GP\QuranProject\imagesWithoutFrame/text (" + str(i) +").mat"
    # lineSegmantationFinal.main(15,path,1,i)
    # # # # lineSegmentation.main(15,text,1)
    # print "finish segmentation"
    # # # # M.saveLines( i ,nargout=0)
    M.ayaDetection(i,nargout=0)
    # M.mainBody('ayat.mat',nargout=0)
    # secondaries.main()
    # name = "database/page (" + str(i) + ").mat"
    # M.structing(name,nargout=0)
    # print "start saving"
    # M.diacritics(i,nargout=0)
    # print "finished saving"
    # print "--------------------------------------------------------"

