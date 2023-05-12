page 50059 "Approve Delivery Material List"
{
    Caption = 'Washing Shipment List';
    CardPageID = "Approve DL Card";
    PageType = List;
    SourceTable = "Material Delivery Header";
    SourceTableView = sorting("Req. No.") order(ascending) where("From Washing" = filter(1));
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field(Status; Status) { ApplicationArea = all; StyleExpr = StyEx; }
                field("Req. No."; "Req. No.") { ApplicationArea = all; }
                field("Req. Date"; "Req. Date") { ApplicationArea = all; }
                field("Req. By"; "Req. By") { ApplicationArea = all; }
                field(Remark; Remark) { ApplicationArea = all; }
                field("Ref. Document"; "Ref. Document") { ApplicationArea = all; }
                field(Process; Process) { ApplicationArea = all; }
                field("Create Date"; "Create Date") { ApplicationArea = all; Editable = false; }
                field("Create By"; "Create By") { ApplicationArea = all; Editable = false; }
                field("Shipment No."; "Shipment No.") { ApplicationArea = all; Editable = false; }
                field("From Washing"; "From Washing") { ApplicationArea = all; }
                field("Approve Date"; "Approve Date") { ApplicationArea = all; }
                field("Approve By"; "Approve By") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {

        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields("Shipment No.");
        if Status = Status::Completed then
            StyEx := 'Favorable';
        if Status <> Status::Completed then
            StyEx := 'Attention';
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        MaterialH: Record "Material Delivery Header";
        invtPS: Page "Invt. Shipment";
    begin
        if CloseAction = Action::OK then begin

        end;
    end;

    var
        utility: Codeunit Utility;
        DocNo: Code[20];
        StyEx: Text[20];

    procedure setDoc(Docx: Code[20])
    begin
        DocNo := Docx;

    end;






}