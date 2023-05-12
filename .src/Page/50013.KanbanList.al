page 50013 "Kanban List"
{
    PageType = List;
    SourceTable = "Kanban List";
    SourceTableView = where(Status = filter(Active));
    UsageCategory = Lists;
    ApplicationArea = all;
    RefreshOnActivate = true;
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    DelayedInsert = true;


    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                // field(Seq; Seq)
                // {
                //     ApplicationArea = all;
                // }
                field("Master No."; "Master No.") { ApplicationArea = all; }
                field("Part No."; "Part No.") { ApplicationArea = all; }
                field("Part Name"; "Part Name") { ApplicationArea = all; }
                field(Model; Model) { ApplicationArea = all; }
                field(Maker; Maker) { ApplicationArea = all; Editable = false; }
                field(Classification; Classification) { ApplicationArea = all; }
                field(Address; Address) { ApplicationArea = all; }
                field(Location; Location) { ApplicationArea = all; }
                field(Process; Process) { ApplicationArea = all; }
                field("Tool#"; "Tool#") { ApplicationArea = all; }
                field(Note; Note) { ApplicationArea = all; }
                field(Qty; Qty) { ApplicationArea = all; }
                field(Run; Run) { ApplicationArea = all; }
                field("Lead Time"; "Lead Time") { ApplicationArea = all; }
                field(Quotation; Quotation) { ApplicationArea = all; Editable = false; }
                field(Vendor; Vendor) { ApplicationArea = all; Editable = false; }
                field(Status; Status) { ApplicationArea = all; }
                field(Revision; Revision) { ApplicationArea = all; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import1)
            {
                ApplicationArea = all;
                Caption = 'Import Excel';
                Image = Import;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    ConigP: Page "Kanban Import List";
                begin
                    Clear(ConigP);
                    ConigP.Run();
                end;
            }
            action(Import)
            {
                ApplicationArea = all;
                Caption = 'Import Package';
                Image = Import;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    ConigP: Page "Config. Packages";
                begin
                    Clear(ConigP);
                    ConigP.Run();
                end;
            }
            action(Kanban)
            {
                ApplicationArea = all;
                Caption = 'Print Kanban';
                Image = Print;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    KReport: Report "Kanban Report";
                    KbList: Record "Kanban List";
                begin
                    Clear(KReport);
                    KbList.Reset();
                    CurrPage.SetSelectionFilter(KbList);
                    KReport.SetTableView(KbList);
                    KReport.RunModal();
                end;
            }
            action(PLabel)
            {
                ApplicationArea = all;
                Caption = 'Print Label';
                Image = Print;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    PLabel: Report "Kanban Label";
                    KbList: Record "Kanban List";
                begin
                    Clear(PLabel);
                    KbList.Reset();
                    CurrPage.SetSelectionFilter(KbList);
                    PLabel.SetTableView(KbList);
                    PLabel.RunModal();
                end;
            }
            group(DeleteItem)
            {
                Caption = 'Delete Kanban';
                action(DL)
                {
                    ApplicationArea = all;
                    Caption = 'Delete Item Select';
                    Image = Delete;
                    trigger OnAction()
                    var
                        ItemS: Record Item;
                        KanbanList: Record "Kanban List";
                    begin

                        //     ItemS.Reset();
                        //     ItemS.SetRange(TypeIM, 'IMP');
                        //     if ItemS.Find('-') then begin
                        //         repeat
                        //             ItemS.Delete(false);
                        //         until Next = 0;
                        //     end;
                        // end;
                        if Confirm('??? Not Standdard Delete Item on Item Table?') then begin
                            KanbanList.Reset();
                            CurrPage.SetSelectionFilter(KanbanList);
                            if KanbanList.Find('-') then begin
                                repeat
                                    KanbanList.Delete(true);
                                until KanbanList.Next = 0;

                            end;
                        end;
                        CurrPage.Update();
                    end;
                }

            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        CalcFields(Quotation);
        CalcFields(Vendor);
        CalcFields(Maker);
    end;

    var
        Sty: Boolean;
}