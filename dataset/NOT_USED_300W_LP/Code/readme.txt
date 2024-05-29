The 300W-LP provides the synthesized face images with face profiling
It can be used as follows:

1. Applying for the Basel Face Model (BFM) on "http://faces.cs.unibas.ch/bfm/main.php?nav=1-0&id=basel_face_model".
2. Copy the "01_MorphableModel.mat" file in the BFM to ModelGeneration/.
3. Run the "ModelGenerate.m" to generate the shape model "Model_Shape.mat" and copy it to current folder. Note that this model is the same as our former work in "http://www.cbsr.ia.ac.cn/users/xiangyuzhu/projects/HPEN/main.htm".
4. Run the "main_show_with_model.m".

While if you are only interested with landmarks, you can refer to the "main_show_landmarks.m"
