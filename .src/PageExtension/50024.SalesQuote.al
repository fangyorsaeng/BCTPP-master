pageextension 50024 "Sales Quote Ex" extends "Sales Quote"
{
    layout
    {
        modify("Shortcut Dimension 1 Code") { Visible = true; ApplicationArea = all; Importance = Promoted; }
        modify("Shortcut Dimension 2 Code") { Visible = true; ApplicationArea = all; Importance = Promoted; }
        moveafter("Document Date"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        modify("Sell-to Address")
        {
            Importance = Promoted;
        }
        modify("Sell-to Address 2")
        {
            Importance = Promoted;
        }
        addafter("Sell-to Address 2")
        {
            field("Address 3"; "Address 3")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
        }
        modify("Due Date")
        {
            Importance = Additional;
        }
        modify("Requested Delivery Date")
        {
            Importance = Additional;
        }
        modify("Document Date")
        {
            ApplicationArea = all;
            Importance = Promoted;
        }
        modify("Your Reference")
        {
            Importance = Promoted;
            Visible = false;
        }
        addafter(Status)
        {
            field("RE: Quotation for"; "RE: Quotation for")
            {
                ApplicationArea = all;
                Importance = Promoted;
            }
            field("Remark HD"; "Remark HD")
            {
                ApplicationArea = all;
                Importance = Promoted;
                Caption = 'Remark';
            }
            field("Drawing and Material"; "Drawing and Material")
            {
                ApplicationArea = all;
                Importance = Promoted;
                Visible = false;
            }
            field("CRRNCY Initial Die Cost"; "CRRNCY Initial Die Cost")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
            field("CRRNCY Price/Piece"; "CRRNCY Price/Piece")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
        }
        modify("External Document No.")
        {
            Visible = false;
        }
        addafter(SalesLines)
        {
            part(SalesLinesAnnual; "Sales Quote Sub Annual")
            {
                ApplicationArea = Basic, Suite;
                Editable = "Sell-to Customer No." <> '';
                Enabled = "Sell-to Customer No." <> '';
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }

        }
        addbefore("Invoice Details")
        {
            group(Condition)
            {
                Caption = 'Conditions';
                field("Condition 1"; "Condition 1") { ApplicationArea = all; }
                field("Condition 2"; "Condition 2") { ApplicationArea = all; }
                field("Condition 3"; "Condition 3") { ApplicationArea = all; }
                field("Condition 4"; "Condition 4") { ApplicationArea = all; }
                field("Condition 5"; "Condition 5") { ApplicationArea = all; }
                field("Condition 6"; "Condition 6") { ApplicationArea = all; }
                field("Condition 7"; "Condition 7") { ApplicationArea = all; }
                field("Condition 8"; "Condition 8") { ApplicationArea = all; }
                field("Condition 9"; "Condition 9") { ApplicationArea = all; }
                field("Condition 10"; "Condition 10") { ApplicationArea = all; }

            }
        }
    }
    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        addafter(Print)
        {
            action(Print2)
            {
                ApplicationArea = all;
                Image = Print;
                Caption = 'Print Quote';
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SalesQ: Record "Sales Header";
                    PrintQ1: Report "Sales Quote Template 1";
                begin
                    Clear(PrintQ1);
                    SalesQ.Reset();
                    CurrPage.SetSelectionFilter(SalesQ);
                    PrintQ1.SetTableView(SalesQ);
                    PrintQ1.RunModal();
                end;
            }
            // action(Print3)
            // {
            //     ApplicationArea = all;
            //     Image = Print;
            //     Caption = 'Print Quote Template 2';
            //     Promoted = true;
            //     PromotedCategory = Category9;
            //     PromotedIsBig = true;
            //     trigger OnAction()
            //     var
            //         SalesQ: Record "Sales Header";
            //         PrintQ1: Report "Sales Quote Template 2";
            //     begin
            //         Clear(PrintQ1);
            //         SalesQ.Reset();
            //         CurrPage.SetSelectionFilter(SalesQ);
            //         PrintQ1.SetTableView(SalesQ);
            //         PrintQ1.RunModal();
            //     end;
            // }

        }
        addafter(CopyDocument)
        {
            action(copyCondition)
            {
                Caption = 'Default Condition';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    CustomerS: Record Customer;
                    ConditionHD: Record "Condition Template Customer";
                begin
                    if Confirm('Do you want Copy Default Condition?') then begin

                        ConditionHD.Reset();
                        ConditionHD.SetRange("Condition Code", Rec."Sell-to Customer No.");
                        if ConditionHD.Find('-') then begin
                            Rec."Condition 1" := '';
                            Rec."Condition 2" := '';
                            Rec."Condition 3" := '';
                            Rec."Condition 4" := '';
                            Rec."Condition 5" := '';
                            Rec."Condition 6" := '';
                            Rec."Condition 7" := '';
                            Rec."Condition 8" := '';
                            Rec."Condition 9" := '';
                            Rec."Condition 10" := '';
                            repeat

                                case ConditionHD."Seq." of
                                    1:
                                        Rec."Condition 1" := ConditionHD.Detail;
                                    2:
                                        Rec."Condition 2" := ConditionHD.Detail;
                                    3:
                                        Rec."Condition 3" := ConditionHD.Detail;
                                    4:
                                        Rec."Condition 4" := ConditionHD.Detail;
                                    5:
                                        Rec."Condition 5" := ConditionHD.Detail;
                                    6:
                                        Rec."Condition 6" := ConditionHD.Detail;
                                    7:
                                        Rec."Condition 7" := ConditionHD.Detail;
                                    8:
                                        Rec."Condition 8" := ConditionHD.Detail;
                                    9:
                                        Rec."Condition 9" := ConditionHD.Detail;
                                    10:
                                        Rec."Condition 10" := ConditionHD.Detail;
                                end;
                            until ConditionHD.Next = 0;
                        end;
                    end;
                end;
            }
        }
    }
}