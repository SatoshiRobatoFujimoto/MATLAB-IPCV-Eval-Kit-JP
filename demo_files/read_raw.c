// ����MEX�֐��̎g����
//    raw = read_raw('Raw�f�[�^�̃t�@�C����', �t�H�[�}�b�g);
//       �t�H�[�}�b�g�F1 => Little-Endian
//                    2 => Big-Endian
#include "mex.h"
#include "read_raw_main.h"

// ���b�p�[�֐���`
void mexFunction(int           nlhs,      //�o�̓p�����[�^��
                 mxArray       *plhs[],   //�o�̓p�����[�^�ւ̃|�C���^�z��
                 int           nrhs,      //���̓p�����[�^��
                 const mxArray *prhs[]) { //���̓p�����[�^�ւ̃|�C���^�z��

    char   *fileName;                      //��1����
    double *format;                        //��2����
    unsigned short  height;           //C�֐�����̖߂�l
    unsigned short  width;            //C�֐�����̖߂�l
    unsigned short *pOutRaw;          //C�֐�����̖߂�l
    
   
    fileName = mxArrayToString(prhs[0]);   //�������m�ۂ��A��1����(������)��NULL���Ō�ɕt�����ăR�s�[
                                           //(�����ւ̃|�C���^��ϕԂ�)
    format   = mxGetPr(prhs[1]);           //��2����(double)�ւ̃|�C���^

  // C�֐����Ă� **********************************
    read_raw_main(fileName, (int)*format, &height, &width, &pOutRaw);

  // C�֐�����̖߂�l�� plhs[0]�֊i�[
    plhs[0] = mxCreateNumericMatrix(height, width, mxUINT16_CLASS, mxREAL);   //������������
    memcpy((unsigned short *)mxGetData(plhs[0]), pOutRaw, height * width * sizeof(unsigned short));
    free(pOutRaw);

    mxFree(fileName);
}

// Copyright 2014 The MathWorks, Inc.
