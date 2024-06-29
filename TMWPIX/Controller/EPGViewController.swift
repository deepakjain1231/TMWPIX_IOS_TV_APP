//
//  EPGViewController.swift
//  TMWPIX
//
//  Created by Apple on 26/08/2022.
//

import Foundation

import UIKit
import SDWebImage

class EPGViewController: TMWViewController {
    
    var indx_channel = 0
    let contentCellIdentifier = "ContentCellIdentifier"
    let numerOfcolumns = 96
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblToday: UILabel!
    
    //    @IBOutlet weak var channelCollectionViewController: UICollectionView!
    //    @IBOutlet weak var programCollectionViewController: UICollectionView!
    
    var arr_time:[String] = ["00:00 AM","12:15 AM","12:30 AM","12:45 AM",
                         "1:00 AM","1:15 AM","1:30 AM","1:45 AM",
                         "2:00 AM","2:15 AM","2:30 AM","2:45 AM",
                         "3:00 AM", "3:15 AM","3:30 AM","3:45 AM",
                         "4:00 AM","4:15 AM","4:30 AM","4:45 AM",
                         "5:00 AM","5:15 AM","5:30 AM","5:45 AM",
                         "6:00 AM","6:15 AM","6:30 AM","6:45 AM",
                         "7:00 AM", "7:15 AM","7:30 AM","7:45 AM",
                         "8:00 AM","8:15 AM","8:30 AM","8:45 AM",
                         "9:00 AM", "9:15 AM","9:30 AM","9:45 AM",
                         "10:00 AM","10:15 AM","10:30 AM","10:45 AM",
                         "11:00 AM", "11:15 AM","11:30 AM","11:45 AM",
                         "12:00  PM","12:15 PM","12:30 PM","12:45 PM",
                         "1:00 PM","1:15 PM", "1:30 PM", "1:45 PM",
                         "2:00 PM","2:15 PM", "2:30 PM", "2:45 PM",
                         "3:00 PM","3:15 PM", "3:30 PM", "3:45 PM",
                         "4:00 PM","4:15 PM", "4:30 PM", "4:45 PM",
                         "5:00 PM","5:15 PM", "5:30 PM", "5:45 PM",
                         "6:00 PM","6:15 PM", "6:30 PM", "6:45 PM",
                         "7:00 PM","7:15 PM", "7:30 PM", "7:45 PM",
                         "8:00 PM","8:15 PM", "8:30 PM", "8:45 PM",
                         "9:00 PM","9:15 PM", "9:30 PM", "9:45 PM",
                         "10:00 PM","10:15 PM", "10:30 PM", "10:45 PM",
                         "11:00 PM","11:15 PM", "11:30 PM", "11:45 PM",
    ]
    var epgData = [EPGInfo]()
    
    var programsData = [Program]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.collectionView.delegate = self
        let customCollectionViewLayout = self.collectionView.collectionViewLayout as! CustomCollectionViewLayout
        customCollectionViewLayout.numberOfColumns = self.numerOfcolumns
        self.collectionView.dataSource = self
        self.loadingIndicator.startAnimating()
        EPGAPI.getEPGData(delegate: self)
        
        let nowDateValue = utils.getLocalTime()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        lblToday.text = formatter.string(from: nowDateValue)
        
        let current_time = Date().nextHalfHour // "May 23, 2020 at 1:00  AM"
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        let str_currentttime = formatter.string(from: current_time)
        debugPrint(str_currentttime)
        if let indx = self.arr_time.firstIndex(where: { dic_time in
            return dic_time == str_currentttime
        }) {
            debugPrint("selected_indx====>>\(indx)")
            self.indx_channel = indx
        }
    }
    
    
    
    override var preferredFocusedView: UIView? {
        get {
            return self.collectionView
        }
    }
    
#if TARGET_OS_IOS
    //======= Orientation Control ===========
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
    //======================================
#endif
    
    @IBAction func viewDismissed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


//extension EPGViewController : UICollectionViewDataSource {
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.collectionView{ // for time
//            return time.count
//        }
//        else if collectionView == self.channelCollectionViewController{ // for channel category
//            return epgData.count
//        }else{ // for program
//            return programsData.count
//        }
//
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if collectionView == self.collectionView{  // for time
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeViewCell
//
//            cell.timeText.text = time[indexPath.row]
////            self.time = self.time + 0.15
//            return cell
//        }
//        else if collectionView == self.channelCollectionViewController{ // for catogery
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChannelCategoryViewCell
//
//            cell.channelNumber.text = String(indexPath.row)
//            cell.channelImage.sd_setImage(with: URL(string: epgData[indexPath.row].image!))
//
//            return cell
//        }
//        else{ // For Program Table
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProgramViewCell
//
////            cell.programName.text = epgData[0].program![indexPath.row].title!
//            cell.time.text = "1:00-7:00"
//            cell.programName.text = programsData[indexPath.row].title!
//
//            return cell
//        }
//
//    }
//}

//extension EPGViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
//                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if collectionView == self.collectionView{ // for time
//            return CGSize(width: self.collectionView.frame.size.width / 8 - 20, height: self.collectionView.frame.size.height)
//        }
//        else if collectionView == self.channelCollectionViewController{ // for catogery
//            return CGSize(width: self.channelCollectionViewController.frame.size.width - 10, height: self.channelCollectionViewController.frame.size.height / 5)
//        }
//        else{ // For Program
//            return CGSize(width: self.programCollectionViewController.frame.size.width / 4 , height: self.programCollectionViewController.frame.size.height / 5)
//        }
//
//    }
//
//}

//extension EPGViewController{
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == channelCollectionViewController {
//            let indexPath = channelCollectionViewController.indexPathsForVisibleItems.first
//            self.programCollectionViewController.scrollToItem(at: indexPath!, at: UICollectionView.ScrollPosition.top, animated: true)
//        }
//
//        if scrollView == programCollectionViewController{
//            let indexPath = programCollectionViewController.indexPathsForVisibleItems.first
//            self.channelCollectionViewController.scrollToItem(at: indexPath!, at: UICollectionView.ScrollPosition.top, animated: true)
//        }
//
//    }
//}


//extension EPGViewController : UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        if collectionView == self.collectionView{ // for time
//
//        }
//        else if collectionView == self.channelCollectionViewController{ // for catogery
//
//            let nextViewController = storyboard.instantiateViewController(withIdentifier: "MediaViewController") as! MediaViewController
//            nextViewController.ImageUrl = epgData[indexPath.row].image!
//            nextViewController.VideoURl = epgData[indexPath.row].url!
//            nextViewController.name = epgData[indexPath.row].nome!
//
//            nextViewController.Channeltext = String(epgData[indexPath.row].numero!)
//            self.present(nextViewController, animated:true, completion:nil)
//        }
//        else{ // For Program
//
//        }
//
//
//    }
//}

// MARK: - UICollectionViewDataSource
extension EPGViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return epgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numerOfcolumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellIdentifier,
                                                      for: indexPath) as! ContentCollectionViewCell
        cell.tag = indexPath.row
        cell.accessibilityHint = "\(indexPath.section)"
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor
        
        
        //        if indexPath.section % 2 != 0 {
        //            cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        //        } else {
        //            cell.backgroundColor = UIColor.white
        //        }
        
        cell.ChannelImage.sd_setImage(with: nil)
        cell.contentLabel.text = ""
        cell.backgroundColor = utils.UIColorFromRGB(rgbValue: 0x292929)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                dateFormatter.amSymbol = " AM"
                dateFormatter.pmSymbol = " PM"
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                cell.contentLabel.text = dateFormatter.string(from: utils.getLocalTime())
                //                cell.contentLabel.text = "Today"
            } else {
                cell.contentLabel.text = self.arr_time[indexPath.row-1]
            }
        } else {
            if indexPath.row == 0 {
                cell.contentLabel.text = String(epgData[indexPath.section-1].numero!)
                cell.ChannelImage.sd_setImage(with: URL(string: epgData[indexPath.section-1].image!))
                
            } else {
                let row_index = indexPath.row - 1
                let section_index = indexPath.section - 1
                if row_index < epgData[section_index].program!.count {
                    // check size based on data
                    let startDateTime = epgData[section_index].program![row_index].start!
                    let stopDateTime = epgData[section_index].program![row_index].stop!
                    
                    if(utils.isCurrentTimeisInRange(startTime: startDateTime, endTime: stopDateTime)){
                        cell.backgroundColor = UIColor.blue
                    }else{
                        cell.backgroundColor = utils.UIColorFromRGBValue(red: 31, green: 31, blue: 31)
                    }
                    
                    let programName =  epgData[section_index].program![row_index].title!
                    cell.contentLabel.text = programName
                }
                
            }
        }
        
        
        
        
        
        cell.did_completation_Focus = { (indx_tag_row, indx_tag_section) in
            if indx_tag_row == 100 {
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = UIColor.white.cgColor
            }
            else if indexPath.section == indx_tag_section && indexPath.row == indx_tag_row {
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = utils.UIColorFromRGBValue(red: 189, green: 0, blue: 54).cgColor
            }
            else {
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = UIColor.white.cgColor
            }
        }
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate 
extension EPGViewController : UICollectionViewDelegate {
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        let indx_path = IndexPath.init(row: self.indx_channel, section: 0)
        return indx_path
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 || indexPath.row == 0 { return }
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "MediaViewController") as! MediaViewController
        nextViewController.ImageUrl = epgData[indexPath.section-1].image!
        nextViewController.VideoURl = epgData[indexPath.section-1].url!
        nextViewController.name = epgData[indexPath.section-1].nome!
        nextViewController.Channeltext = String(epgData[indexPath.section-1].numero!)
        nextViewController.desc = epgData[indexPath.section-1].program![indexPath.row-1].title
        nextViewController.channelID = String(epgData[indexPath.section-1].id!)
        nextViewController.Channeltext = String(epgData[indexPath.section-1].numero!)
        nextViewController.is_epg = true

        self.present(nextViewController, animated:true, completion:nil)
    }
}

extension EPGViewController{
    func epgDataresponseHandler( epgData:[EPGInfo]){
        self.loadingIndicator.stopAnimating()
        
        for data in epgData{
            programsData.append(contentsOf: data.program!)
            print(data.nome!)
        }
        self.epgData = epgData
        let customCollectionViewLayout = self.collectionView.collectionViewLayout as! CustomCollectionViewLayout
        customCollectionViewLayout.collectionData = self.epgData
        self.collectionView.reloadData()
        //        self.channelCollectionViewController.reloadData()
        //        self.programCollectionViewController.reloadData()
        
        //let index = utils.getCurrentTimeDifferenceInMins() / 15 + 1
        let indexPath = IndexPath(item: self.indx_channel, section: 1)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        //self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredVertically, animated: true)
        
        setNeedsFocusUpdate()
    }
}



extension Date {
    var minute: Int { Calendar.current.component(.minute, from: self) }
    var nextHalfHour: Date {
        Calendar.current.nextDate(after: self, matching: DateComponents(minute: minute >= 30 ? 0 : 30), matchingPolicy: .strict)!
    }
}
