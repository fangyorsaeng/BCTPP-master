page 50011 "PR Copy Line"
{
    Editable = true;
    SourceTable = "Purchase Line";
    SourceTableView = where("PO Status" = filter(Open), "Document Type" = filter(Quote), "PO No." = const(''), Quantity = filter(<> 0));
    RefreshOnActivate = true;
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Tasks;
    ModifyAllowed = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Select; Select)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    Caption = 'PR No.';
                    Editable = false;
                }

                field("No."; "No.")
                {
                    ApplicationArea = all;
                    Caption = 'Part No.';
                    CaptionClass = 'Part No.';
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Caption = 'Part Name';
                    CaptionClass = 'Part Name';
                    Editable = false;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = all;
                    Caption = 'Model';
                    Editable = false;
                }
                field("Supplier Name"; "Supplier Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Ref Quote No."; "Ref Quote No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }

        }

    }
    actions
    {
        area(Processing)
        {
            action(Select2)
            {
                Caption = 'Get to Line';
                Visible = true;
                ApplicationArea = all;
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    CopyToPO();
                    clearSelect();
                    CurrPage.Close();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        CalcFields("PO No.");
        SetRange("PO No.", '');
    end;

    trigger OnClosePage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        Select := false;
    end;

    var
        DocHeader: Code[20];
        utility: Codeunit Utility;

    procedure Setdoc(Docx: Code[20])
    begin
        DocHeader := Docx;
    end;

    procedure CopyToPO()
    var
        POLine: Record "Purchase Line";
        PRLine: Record "Purchase Line";
        POHD: Record "Purchase Header";
        rows1: Integer;
        ItemS: Record Item;
    begin
        if DocHeader = '' then
            exit;
        rows1 := 0;
        POLine.Reset();
        POLine.SetRange("Document No.", DocHeader);
        if POLine.FindLast() then
            rows1 := POLine."Line No.";
        POHD.Reset();
        POHD.SetRange("No.", DocHeader);
        POHD.SetRange(Status, POHD.Status::Open);
        if POHD.Find('-') then begin

            PRLine.Reset();
            PRLine.SetRange(Select, true);
            PRLine.SetRange("Select UserID", UserId);
            PRLine.SetRange("Document Type", "Document Type"::Quote);
            if PRLine.Find('-') then begin
                repeat
                    rows1 := rows1 + 10000;
                    POLine.Init;
                    POLine."Document No." := DocHeader;
                    POLine."Line No." := rows1;
                    POLine."Document Type" := POLine."Document Type"::Order;
                    POLine.Type := POLine.Type::Item;
                    POLine.Validate("No.", PRLine."No.");
                    POLine.Validate("Unit of Measure Code", PRLine."Unit of Measure Code");
                    POLine.Validate(Quantity, PRLine.Quantity);
                    POLine.Validate("Location Code", PRLine."Location Code");
                    if PRLine."Direct Unit Cost" > 0 then
                        POLine.Validate("Direct Unit Cost", PRLine."Direct Unit Cost")
                    else begin
                        ItemS.Reset();
                        ItemS.SetRange("No.", PRLine."No.");
                        if ItemS.Find('-') then
                            POLine.Validate("Direct Unit Cost", ItemS."Unit Cost");

                    end;
                    POLine."Expected Receipt Date" := PRLine."Expected Receipt Date";
                    POLine."Quote Line" := PRLine."Line No.";
                    POLine."Quote No." := PRLine."Document No.";
                    POLine.Description := PRLine.Description;
                    POLine."Description 2" := PRLine."Description 2";
                    POLine."Ref Quote No." := PRLine."Ref Quote No.";
                    POLine."Supplier Name" := PRLine."Supplier Name";
                    POLine.Maker := PRLine.Maker;
                    POLine.LeadTime := PRLine.LeadTime;
                    POLine."PO Status" := POLine."PO Status"::Open;
                    POLine."Create Date" := CurrentDateTime;
                    POLine."Create By" := utility.UserFullName(UserId);
                    POLine.Classification := PRLine.Classification;


                    POLine.Insert(true);
                until PRLine.Next = 0;
            end;
        end;



    end;

    procedure clearSelect()
    var
        PRLine: Record "Purchase Line";
    begin
        PRLine.Reset();
        PRLine.SetRange(Select, true);
        PRLine.SetRange("Select UserID", UserId);
        if PRLine.find('-') then begin
            repeat
                PRLine."Select UserID" := '';
                PRLine.Select := false;
                PRLine.Modify(false);
            until PRLine.Next = 0;
        end;
    end;

}