classdef I5_02_CarDetection < vision.labeler.AutomationAlgorithm
    % Copyright 2018 The MathWorks, Inc.
    
    %----------------------------------------------------------------------
    % Step 1: �A���S���Y���̐����̋L�q
    properties(Constant)
        
        % Name: �A���S���Y����
        Name = '�Ԍ��o��';
        
        % Description: 1�s�̃A���S���Y������
        Description = '�Ԍ��o�A���S���Y��';
        
        % UserDirections: ���s����Ƃ��̊e�X�e�b�v�̐����B
        %                 �Z���z��̊e�v�f��1�̃X�e�b�v�ɊY���B
        UserDirections = {...
            ['�w�K�ς݂̃J�X�P�[�h���o����g�������x�����O���s���܂�']};
        
    end
    
    %---------------------------------------------------------------------
    % Step 2: �A���S���Y�����s���ɕێ�����v���p�e�B���`
    properties
        
        %------------------------------------------------------------------
        % Place your code here
        %------------------------------------------------------------------
        mydetector
        
    end
    
    %----------------------------------------------------------------------
    % Step 3: �A���S���Y�����s�̂��߂̏�����
    methods
        % a) ���x���̃`�F�b�N(�K�v�ȃ��x�������邩�Ȃ���)
        function isValid = checkLabelDefinition(algObj, labelDef)
            
            disp(['Executing checkLabelDefinition on label definition "' labelDef.Name '"'])
            
            %--------------------------------------------------------------
            % Place your code here
            %--------------------------------------------------------------
            isValid = true;
                        
        end
        
        % b) �A���S���Y���̏������������Ă��邩�ǂ���
        function isReady = checkSetup(algObj)
            
            disp('Executing checkSetup')
            
            %--------------------------------------------------------------
            % Place your code here
            %--------------------------------------------------------------
            algObj.mydetector = vision.CascadeObjectDetector('I5_02_carDetector_20151015Bb.xml');
            isReady = true;
            
            
        end
        
        % c) �I�v�V�����Őݒ荀�ڂ�ǉ����邱�Ƃ��ł���
        %    (�ݒ�{�^�����N���b�N�����Ƃ��̓���)
        function settingsDialog(algObj)
            
            disp('Executing settingsDialog')
            
            %--------------------------------------------------------------
            % Place your code here
            %--------------------------------------------------------------
         
            
        end
    end
    
    %----------------------------------------------------------------------
    % Step 4: ���s����A���S���Y���̋L�q
    methods
        % a) �A���S���Y���̏�����
        function initialize(algObj, I)
            
            disp('Executing initialize on the first image frame')
            
            %--------------------------------------------------------------
            % Place your code here
            %--------------------------------------------------------------
            
        end
        
        % b) ���s�{�^�����N���b�N�����Ƃ��̓���
        function autoLabels = run(algObj, I)
            
            disp('Executing run on image frame')
            
            %--------------------------------------------------------------
            % Place your code here
            %--------------------------------------------------------------
            
            bboxes = step(algObj.mydetector,I);
            if ~isempty(bboxes)
                for k = 1:size(bboxes,1)
                    autoLabels(k).Name = 'car'; %#ok<*AGROW>
                    autoLabels(k).Type = labelType('Rectangle');
                    autoLabels(k).Position = bboxes(k,:);
                end
            end
            
        end
        
        % c) �I�����̓���
        function terminate(algObj)
            
            disp('Executing terminate')
            
            %--------------------------------------------------------------
            % Place your code here
            %--------------------------------------------------------------
            
            
        end
    end
end