page 50027 "Plan Header Card"
{
    PageType = Document;
    SourceTable = "Plan Header";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Plan Name"; "Plan Name")
                {
                    ApplicationArea = all;

                }
                field("Plan Description"; "Plan Description")
                {
                    ApplicationArea = all;
                }
                field("Plan Year"; "Plan Year")
                {
                    ApplicationArea = all;
                }
                field("Plan Month"; "Plan Month")
                {
                    ApplicationArea = all;
                }
                field("Plan Type"; "Plan Type")
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field("Create Date"; "Create Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Create By"; "Create By")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
            part(LinePlanx; "Plan Line Sub")
            {
                Caption = 'Plan Line.';
                ApplicationArea = all;
                Enabled = "Plan Name" <> '';
                SubPageLink = "ref. Plan Name" = field("Plan Name");
                UpdatePropagation = Both;


            }
        }

    }
    actions
    {

        area(Processing)
        {
            action(Posted)
            {
                Caption = 'Load Data';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                Visible = true;
                trigger OnAction()
                var
                    CopItem: Record "List Item On Report";
                    LoadReport: Report "Load Data Item On Report";
                    PlanH: Record "Plan Header";
                begin
                    if Confirm('Do you want Copy Item New?') then begin

                        Clear(LoadReport);
                        CurrPage.SetSelectionFilter(PlanH);
                        LoadReport.SetTableView(PlanH);
                        LoadReport.RunModal();
                        CurrPage.Update(true);
                    end;
                end;
            }
            group(report)
            {
                Caption = 'Report';

                action(CalsBefor)
                {
                    ApplicationArea = all;
                    Caption = 'Calc. Report';
                    Image = Print;
                    Visible = false;
                    trigger OnAction()
                    begin
                        PlanUnit.CreateLineReportSales(Rec);
                        Message('Completed.');
                    end;
                }

                action(ReportFactory)
                {
                    ApplicationArea = all;
                    Caption = 'Report Production Actual';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    Image = Print;
                    Visible = true;
                    trigger OnAction()
                    var
                        PlanH: Record "Plan Header";
                        ReportP: Report "Plan Production Actual";
                    begin
                        PlanH.Reset();
                        PlanH.SetRange("Plan Name", Rec."Plan Name");
                        if PlanH.Find('-') then begin
                            Clear(ReportP);
                            ReportP.setDoc(PlanH."Plan Name");
                            ReportP.SetTableView(PlanH);
                            ReportP.RunModal();
                        end;
                    end;

                }
                action(ReportSales)
                {
                    ApplicationArea = all;
                    Caption = 'Report Sales';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    //PromotedIsBig = true;
                    Image = Print;
                    Visible = true;
                    trigger OnAction()
                    var
                        ReportP: Report "Plan Sales List";
                        PlanReport: Record "Plan Report";
                        PlanH: Record "Plan Header";
                    begin

                        PlanH.Reset();
                        PlanH.SetRange("Plan Name", Rec."Plan Name");
                        if PlanH.Find('-') then begin
                            Clear(ReportP);
                            ReportP.SetTableView(PlanH);
                            ReportP.RunModal();
                        end;

                    end;
                }
                action(ReportWashing)
                {
                    ApplicationArea = all;
                    Caption = 'Report Washing';
                    // Promoted = true;
                    //PromotedCategory = Process;
                    // PromotedIsBig = true;
                    Image = Print;
                    Visible = true;
                    trigger OnAction()
                    var
                        PlanH: Record "Plan Header";
                        ReportP: Report "Plan Washing";
                    begin
                        PlanH.Reset();
                        PlanH.SetRange("Plan Name", Rec."Plan Name");
                        if PlanH.Find('-') then begin
                            Clear(ReportP);
                            ReportP.SetTableView(PlanH);
                            ReportP.RunModal();
                        end;
                    end;
                }
                action(ReportProducList)
                {
                    ApplicationArea = all;
                    Caption = 'Report Production List';
                    Image = Print;
                    Visible = true;
                    trigger OnAction()
                    var
                        PlanH: Record "Plan Header";
                        ReportP: Report "Production Plan";
                    begin
                        Clear(ReportP);
                        PlanH.Reset();
                        PlanH.SetRange("Plan Name", Rec."Plan Name");
                        if PlanH.Find('-') then;
                        ReportP.setDoc(Rec."Plan Name", '');
                        ReportP.SetTableView(PlanH);
                        ReportP.RunModal();
                    end;
                }
                action(MaterialStockCard)
                {
                    ApplicationArea = all;
                    Caption = 'Material Stock Card';
                    Image = Print;
                    Visible = true;
                    trigger OnAction()
                    var
                        ItemS: Record Item;
                        MaterialStock: Report "Material Stock Card";
                    begin
                        Clear(MaterialStock);
                        // ItemS.Reset();
                        // ItemS.SetRange("No.", Rec."Part No.");
                        // MaterialStock.SetTableView(ItemS);
                        MaterialStock.RunModal();
                    end;
                }


            }
            group(Calculate)
            {
                Caption = 'Calculate';
                Image = Calculate;

                action(CalFromSO)
                {
                    Caption = 'Calculate From SO';
                    Image = Sales;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        SaleH: Record "Sales Header";
                        SaleL: Record "Sales Line";
                        StartDate: Date;
                        EndDate: Date;
                        PlanLine: Record "Plan Line Sub";
                        SumQ: Decimal;
                        SalesD: Integer;
                        CKA: Integer;
                    begin
                        StartDate := 0D;
                        if "Plan Year".AsInteger() > 0 then begin
                            StartDate := DMY2Date(1, Rec."Plan Month".AsInteger(), Rec."Plan Year".AsInteger());
                            EndDate := CalcDate('<CM>', StartDate);
                        end;
                        if (Rec."Plan Type" = Rec."Plan Type"::Sales) and (StartDate <> 0D) then begin
                            //Clear//
                            /////////
                            if Confirm('Do you want get Data From Sales Order ?') then begin
                                //PlanUnit.CreateLineReportSales(Rec);
                                PlanUnit.UpdatePlanLine(Rec."Plan Name");
                                Message('Update Completed.');
                                CurrPage.Update();
                            end;
                            //SaleL.SetRange();

                        end
                        else begin
                            Error('Plan Type is Sales only.');
                        end;
                    end;
                }
            }
        }

    }
    trigger OnAfterGetRecord()
    begin

    end;

    var
        utility: Codeunit Utility;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CK: Boolean;
        PlanUnit: Codeunit "Plan Unit";


}