page 50017 "Kanban Import List"
{
    // ApplicationArea = All;
    Caption = 'Kanban Import List';
    PageType = List;
    SourceTable = "Import Kanban";
    // UsageCategory = Lists;
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                }
                field("Kanban No."; Rec."Kanban No.")
                {
                    Caption = 'Kanban#';
                    ApplicationArea = All;
                }
                field("Master No."; Rec."Master No.")
                {
                    Caption = 'Master#';
                    ApplicationArea = All;
                }
                field("Part No."; Rec."Part No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }

                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field(Classification; Rec.Classification)
                {
                    ApplicationArea = All;
                }

                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Zone No."; Rec."Zone No.")
                {
                    ApplicationArea = all;
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = all;
                }
                field(Process; Rec.Process)
                {
                    ApplicationArea = All;
                }
                field(Qty; Rec.Qty)
                {
                    ApplicationArea = All;
                }
                field(Run; Rec.Run)
                {
                    ApplicationArea = All;
                }
                field("Tool#"; Rec."Tool#")
                {
                    ApplicationArea = All;
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                }
                field(Quotation; Rec.Quotation)
                {
                    ApplicationArea = All;
                }
                field(Revision; Rec.Revision)
                {
                    ApplicationArea = Al;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Lead Time"; Rec."Lead Time")
                {
                    ApplicationArea = All;
                }
                field(Maker; Rec.Maker)
                {
                    ApplicationArea = All;
                }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = All;
                }

                field(PD; PD)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import)
            {
                Image = Import;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ImportP: Report "Import Kanban Ex";
                begin
                    Clear(ImportP);
                    ImportP.RunModal();
                end;
            }
            action(ChckData)
            {
                Caption = 'Check Data';
                ApplicationArea = all;
                Image = Check;
                trigger OnAction()
                var
                    ItemS: Record Item;
                    Impkanban: Record "Import Kanban";
                    KanbanList: Record "Kanban List";
                begin
                    checkData();
                    CurrPage.Update();
                end;
            }
            action(Apply)
            {
                Caption = 'Apply Data';
                Image = Apply;
                trigger OnAction()
                var
                    Impkanban: Record "Import Kanban";
                begin
                    Clear(Impkanban);
                    CurrPage.SetSelectionFilter(Impkanban);
                    if Confirm('Do you want Apply Data?') then begin
                        //checkData();
                        InsertData(Impkanban);
                    end;
                end;
            }
            action(DeleteItem)
            {
                Caption = 'Delete Item';
                Image = Delete;
                trigger OnAction()
                var
                    ItemDelete: Report "Delete Item Filter";
                begin
                    if Confirm('Do you want Delete Item Data?') then begin
                        Clear(ItemDelete);
                        ItemDelete.RunModal();
                    end;
                end;
            }
        }
    }
    var
        Utility: Codeunit Utility;

    procedure checkData()
    var
        ItemS: Record Item;
        Impkanban: Record "Import Kanban";
        KanbanList: Record "Kanban List";
    begin
        Impkanban.Reset();
        if Impkanban.Find('-') then begin
            repeat
                ItemS.Reset();
                ItemS.SetRange("No.", Impkanban."Master No.");
                if ItemS.Find('-') then begin
                    Impkanban."Part No." := ItemS."No.";
                end;
                Impkanban.Message := 'Insert Kanban';
                KanbanList.Reset();
                KanbanList.SetRange("Master No.", Impkanban."Kanban No.");
                if KanbanList.Find('-') then begin
                    Impkanban.Message := 'Update Kanban';
                end;
                Impkanban.Modify();

            until Impkanban.Next = 0;
        end;
    end;

    procedure InsertData(var Impkanban: Record "Import Kanban")
    var
        ItemS: Record Item;
        // Impkanban: Record "Import Kanban";
        KanbanList: Record "Kanban List";
    begin
        //Impkanban.Reset();
        Impkanban.SetFilter(Message, '<>%1', '');
        if Impkanban.Find('-') then begin
            repeat
                if Impkanban."Part No." = '' then
                    InsertItem(Impkanban);
                InsertKanban2(Impkanban);
                Impkanban.Delete();
            //Impkanban.Modify();
            until Impkanban.Next = 0;
        end;
    end;

    procedure InsertKanban2(KList: Record "Import Kanban")
    var
        Kanban: Record "Kanban List";
        KlistCheck: Record "Kanban List";
        ItemS: Record Item;
    begin
        if KList.Message = 'Insert Kanban' then begin
            Kanban.Init();
            Kanban."Master No." := KList."Kanban No.";
            Kanban."Create By" := Utility.UserFullName(UserId);
            Kanban."Create Date" := CurrentDateTime;
            Kanban.Validate("Part No.", KList."Master No.");
            Kanban."Part Name" := KList.Description;
            Kanban.Model := KList.Model;
            Kanban.Classification := KList.Classification;
            Kanban."Lead Time" := KList."Lead Time";
            Kanban.Process := KList.Process;
            Kanban.Address := KList.Address;
            Kanban."Tool#" := KList."Tool#";
            Kanban.Qty := KList.Qty;
            Kanban.Run := KList.Run;
            Kanban.Note := KList.Note;
            Kanban.Revision := KList.Revision;
            Kanban.Location := KList.Location;
            Kanban.Status := Kanban.Status::Active;
            Kanban.Maker := KList.Maker;
            Kanban.Vendor := KList.Vendor;
            Kanban.Quotation := KList.Quotation;
            if Kanban."Zone No." = '' then
                Kanban."Zone No." := KList."Zone No.";
            if Kanban."Shelf No." = '' then
                Kanban."Shelf No." := KList."Shelf No.";
            Kanban.Insert();
            Kanban.CalcFields(Maker);
            Kanban.CalcFields(Vendor);
            Kanban.CalcFields(Quotation);
        end else begin
            Kanban.Reset();
            Kanban.SetRange("Master No.", KList."Kanban No.");
            if Kanban.Find('-') then begin
                Kanban."Create By" := Utility.UserFullName(UserId);
                Kanban."Create Date" := CurrentDateTime;
                Kanban."Part Name" := KList.Description;
                Kanban.Model := KList.Model;
                Kanban.Classification := KList.Classification;
                Kanban."Lead Time" := KList."Lead Time";
                Kanban.Process := KList.Process;
                Kanban.Address := KList.Address;
                Kanban."Tool#" := KList."Tool#";
                Kanban.Qty := KList.Qty;
                Kanban.Run := KList.Run;
                Kanban.Note := KList.Note;
                Kanban.Revision := KList.Revision;
                Kanban.Location := KList.Location;


                Kanban.Modify();
                ItemS.Reset();
                ItemS.SetRange("No.", KList."Master No.");
                if ItemS.Find('-') then begin
                    ItemS.Maker := KList.Maker;
                    ItemS.Vendor := KList.Vendor;
                    ItemS."Ref. Quotation" := KList.Quotation;
                    ItemS."Lead Time" := KList."Lead Time";
                    ItemS.Modify();
                end;
            end;

        end;
    end;

    procedure InsertItem(KList: Record "Import Kanban")
    var
        ItemS: Record Item;
        ItemC2: Record item;
        UnitOf: Record "Unit of Measure";
        LocaT: Record Location;
        Location1: Code[20];
    begin
        Clear(ItemS);
        if KList."Part No." = '' then
            KList."Part No." := KList."Master No.";
        with KList do begin

            if KList."Part No." = '' then exit;

            Location1 := '';
            if StrLen(KList.Location) < 10 then
                Location1 := KList.Location;

            if Location1 <> '' then begin
                LocaT.Reset();
                LocaT.SetRange(Code, Location1);
                if NOT LocaT.Find('-') then begin
                    Location1 := '';
                end;
            end;
            ItemC2.Reset();
            ItemC2.SetRange("No.", KList."Part No.");
            if NOT ItemC2.Find('-') then begin
                ItemS.Init();
                //ItemS."No. Series" := '';
                ItemS.Validate("No.", KList."Part No.");
                ItemS.TypeIM := 'IMP-' + format(KList.PD);
                ItemS.Description := KList.Description;
                ItemS."Description 2" := KList.Model;
                ItemS.Maker := KList.Maker;
                ItemS."Vendor Name" := KList.Vendor;
                ItemS.Classification := KList.Classification;
                ItemS.Validate("Item Category Code", 'FACTORY SUPPLY');
                ItemS.Validate("Gen. Prod. Posting Group", 'FAC');
                ItemS.Validate("VAT Prod. Posting Group", 'VAT');
                ItemS.Validate("Inventory Posting Group", 'FAC');
                ItemS."Ref. Quotation" := KList.Quotation;
                ItemS."Lead Time" := KList."Lead Time";
                if Location1 <> '' then
                    ItemS.Location := Location1;
                ItemS."Group PD" := KList.PD;
                ItemS.Insert(true);
                // ItemS.Validate("No.", KList."Part No.");
                ItemS.Validate("Item Tracking Code", 'LOTALL');
                ItemS.Validate("Base Unit of Measure", 'PCS');
                ItemS.Validate("Unit Cost", KList."Unit Price");
                ItemS.Modify();
            end;


        end;
    end;
}
