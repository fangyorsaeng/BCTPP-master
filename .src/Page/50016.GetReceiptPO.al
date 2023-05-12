page 50016 "Get Purchase Line"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Get Purchase Lines';
    // CardPageID = "Purchase Order";
    DataCaptionFields = "Buy-from Vendor No.";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    //PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Order,Release,Posting,Navigate';
    QueryCategory = 'Get Purchase Orders';
    RefreshOnActivate = true;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = CONST(Order), "Outstanding Qty. (Base)" = filter(> 0));
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                showCaption = false;
                field(rNo; rNo) { ApplicationArea = all; Caption = 'Row No.'; Editable = false; }
                field("Document No."; "Document No.") { ApplicationArea = all; Editable = false; StyleExpr = Stry2; Style = Favorable; }
                field("Document Type"; "Document Type") { ApplicationArea = all; Editable = false; }
                field("No."; "No.") { ApplicationArea = all; Editable = false; CaptionClass = 'Part No.'; }
                field(Description; Description) { ApplicationArea = all; Editable = false; CaptionClass = 'Part Name'; }
                field("Unit of Measure Code"; "Unit of Measure Code") { ApplicationArea = all; Editable = false; }
                field(Quantity; Quantity) { ApplicationArea = all; Editable = false; }
                field("Outstanding Quantity"; "Outstanding Quantity") { ApplicationArea = all; Editable = false; }
                field("Quantity Received"; "Quantity Received") { ApplicationArea = all; Editable = false; }
                field("Unit Cost"; "Unit Cost") { ApplicationArea = all; Editable = false; }
                field(Amount; Amount) { ApplicationArea = all; Editable = false; }
                field("Amount Including VAT"; "Amount Including VAT") { ApplicationArea = all; Editable = false; }
                field("Over-Receipt Quantity"; "Over-Receipt Quantity") { ApplicationArea = all; Editable = false; }
                field("Quote No."; "Quote No.") { ApplicationArea = all; Editable = false; }
                field("Invoice Date"; "Invoice Date") { ApplicationArea = all; Editable = false; }
                field("Invoice No"; "Invoice No") { ApplicationArea = all; Caption = 'Invoice No.'; Editable = false; }
                field("PO Status"; "PO Status") { ApplicationArea = all; Editable = false; StyleExpr = Stry; Style = Attention; }
                field("Location Code"; "Location Code") { ApplicationArea = all; Editable = false; }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                Caption = 'Get To Line';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    PurL: Record "Purchase Line";
                    Msg: Integer;
                begin
                    Msg := 0;
                    if DocNo <> '' then begin
                        CurrPage.SetSelectionFilter(PurL);
                        if PurL.Find('-') then begin
                            repeat
                                CopyToWhsr(PurL);
                                Msg += 1;
                            until PurL.Next = 0;
                        end;
                    end;
                    CurrPage.Close();
                end;
            }
        }
    }
    trigger OnInit()
    begin
        rNo := 0;
    end;

    trigger OnOpenPage()
    begin
        CalcFields("H Status");
        SetRange("H Status", Enum::"Purchase Document Status"::Released);
    end;

    trigger OnAfterGetRecord()
    begin
        rNo += 1;
        Stry := false;
        Stry2 := false;
        if "PO Status" = "PO Status"::Cancel then begin
            Stry := true;
        end;
        if ("Invoice No" <> '') then
            Stry2 := true;
    end;

    trigger OnClosePage()
    var
        PurL: Record "Purchase Line";
        Msg: Integer;
    begin


    end;

    var
        rNo: Integer;
        Stry: Boolean;
        Stry2: Boolean;
        DocNo: Code[20];

    procedure setDocNo(Codex: Code[20])
    begin
        DocNo := Codex;
    end;

    procedure CopyToWhsr(var PurL1: Record "Purchase Line")
    var
        WhsH: Record "Warehouse Receipt Header";
        WhsL: Record "Warehouse Receipt Line";
        POH: Record "Purchase Header";
        row1: Integer;
        ItemS: Record Item;
    begin

        ///Check Before//
        WhsL.Reset();
        WhsL.SetRange("No.", DocNo);
        WhsL.SetRange("Source No.", PurL1."Document No.");
        WhsL.SetRange("Source Line No.", PurL1."Line No.");
        if WhsL.Find('-') then begin
            exit;
        end;
        row1 := 0;
        WhsL.Reset();
        WhsL.SetRange("No.", DocNo);
        if WhsL.FindLast() then begin
            row1 := WhsL."Line No.";
        end;

        POH.Reset();
        POH.SetRange("No.", PurL1."Document No.");
        POH.SetRange(Status, POH.Status::Released);
        if POH.Find('-') then begin


            WhsH.Reset();
            WhsH.SetRange("No.", DocNo);
            if WhsH.Find('-') then begin
                ItemS.Reset();
                ItemS.get(PurL1."No.");

                row1 := row1 + 10000;
                WhsL.Reset();
                WhsL.Init();
                WhsL."No." := DocNo;
                WhsL."Line No." := row1;
                WhsL."Source No." := PurL1."Document No.";
                WhsL."Source Line No." := PurL1."Line No.";
                WhsL."Location Code" := WhsH."Location Code";
                WhsL."Source Type" := 39;
                WhsL."Source Subtype" := 1;
                WhsL."Source Document" := Enum::"Warehouse Journal Source Document"::"P. Order";
                WhsL.Validate("Item No.", PurL1."No.");
                WhsL.Description := PurL1.Description;
                WhsL."Description 2" := PurL1."Description 2";
                WhsL."Unit of Measure Code" := PurL1."Unit of Measure Code";
                WhsL."Qty. per Unit of Measure" := PurL1."Qty. per Unit of Measure";
                WhsL."Sorting Sequence No." := row1;
                WhsL.Quantity := PurL1.Quantity;
                WhsL."Qty. (Base)" := PurL1."Quantity (Base)";
                WhsL."Qty. Outstanding" := PurL1."Outstanding Quantity";
                WhsL."Qty. Outstanding (Base)" := PurL1."Outstanding Qty. (Base)";
                WhsL."Qty. Received" := PurL1."Quantity Received";
                WhsL."Qty. Received (Base)" := PurL1."Qty. Received (Base)";
                WhsL."Qty. to Receive" := PurL1."Outstanding Quantity";
                WhsL."Qty. to Receive (Base)" := PurL1."Outstanding Qty. (Base)";
                WhsL.Status := WhsL.Status::"Completely Received";
                WhsL."Starting Date" := PurL1."Document Date";
                WhsL."Due Date" := POH."Due Date";
                WhsL.Grade := ItemS.Grade;
                WhsL.Size := ItemS.Size;
                //Insert//
                WhsL.Insert();
            end;
        end;
    end;
}