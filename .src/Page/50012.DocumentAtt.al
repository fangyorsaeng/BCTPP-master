page 50012 "Document Attach List"
{
    InsertAllowed = false;
    Editable = true;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Document Attachment";
    SourceTableView = where("Document Type" = filter(Quote));
    RefreshOnActivate = true;
    ApplicationArea = all;
    UsageCategory = Tasks;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Select; Select)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        SUserID := UserId;
                    end;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("File Extension"; "File Extension")
                { ApplicationArea = all; Editable = false; }
                field("Attached Date"; "Attached Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(UserN; UserN)
                {
                    Caption = 'Attached by';
                    ApplicationArea = all;
                    Editable = false;
                }
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        Select := false;
        SUserID := '';
        UserN := utility.UserFullName(Format("Attached By"));
    end;

    trigger OnClosePage()
    begin
        if DType = 'ITEM' then begin
            // Message(Rec."File Name");
            // RefDoc."Quotatio"
            DocAtt.Reset();
            DocAtt.SetRange(SUserID, UserId);
            DocAtt.SetRange(Select, true);
            DocAtt.SetRange("Document Type", DocAtt."Document Type"::Quote);
            if DocAtt.Find('-') then begin
                ItemS.Get(ItemNo);
                ItemS."Ref. Quotation" := Rec."File Name";
                ItemS.Modify(false);
            end;

        end;
        ClearSelect();
    end;

    var
        ItemNo: Code[50];
        DType: Code[10];
        ItemS: Record Item;
        DocAtt: Record "Document Attachment";
        utility: Codeunit Utility;
        UserN: Text[50];

    procedure setData(No: Code[50]; DTypex: Code[10])
    begin
        ItemNo := No;
        DType := DTypex;
    end;

    procedure ClearSelect()
    begin
        DocAtt.Reset();
        DocAtt.SetRange(SUserID, UserId);
        DocAtt.SetRange(Select, true);
        DocAtt.SetRange("Document Type", DocAtt."Document Type"::Quote);
        if DocAtt.Find('-') then begin
            repeat
                DocAtt.Select := false;
                DocAtt.SUserID := '';
                DocAtt.Modify(false);
            until DocAtt.Next = 0;
        end;
    end;
}