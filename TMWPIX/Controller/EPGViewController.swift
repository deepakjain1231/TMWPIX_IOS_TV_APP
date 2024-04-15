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
    let contentCellIdentifier = "ContentCellIdentifier"
    let numerOfcolumns = 96
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblToday: UILabel!
    
    //    @IBOutlet weak var channelCollectionViewController: UICollectionView!
    //    @IBOutlet weak var programCollectionViewController: UICollectionView!
    
    var time:[String] = ["00:00AM","12:15AM","12:30AM","12:45AM",
                         "1:00AM","1:15AM","1:30AM","1:45AM",
                         "2:00AM","2:15AM","2:30AM","2:45AM",
                         "3:00AM", "3:15AM","3:30AM","3:45AM",
                         "4:00AM","4:15AM","4:30AM","4:45AM",
                         "5:00AM","5:15AM","5:30AM","5:45AM",
                         "6:00AM","6:15AM","6:30AM","6:45AM",
                         "7:00AM", "7:15AM","7:30AM","7:45AM",
                         "8:00AM","8:15AM","8:30AM","8:45AM",
                         "9:00AM", "9:15AM","9:30AM","9:45AM",
                         "10:00AM","10:15AM","10:30AM","10:45AM",
                         "11:00AM", "11:15AM","11:30AM","11:45AM",
                         "12:00PM","12:15PM","12:30PM","12:45PM",
                         "1:00PM","1:15PM", "1:30PM", "1:45PM",
                         "2:00PM","2:15PM", "2:30PM", "2:45PM",
                         "3:00PM","3:15PM", "3:30PM", "3:45PM",
                         "4:00PM","4:15PM", "4:30PM", "4:45PM",
                         "5:00PM","5:15PM", "5:30PM", "5:45PM",
                         "6:00PM","6:15PM", "6:30PM", "6:45PM",
                         "7:00PM","7:15PM", "7:30PM", "7:45PM",
                         "8:00PM","8:15PM", "8:30PM", "8:45PM",
                         "9:00PM","9:15PM", "9:30PM", "9:45PM",
                         "10:00PM","10:15PM", "10:30PM", "10:45PM",
                         "11:00PM","11:15PM", "11:30PM", "11:45PM",
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
        formatter.dateFormat = "yyyy - MM - dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        lblToday.text = formatter.string(from: nowDateValue)
        
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
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                cell.contentLabel.text = dateFormatter.string(from: utils.getLocalTime())
                //                cell.contentLabel.text = "Today"
            } else {
                cell.contentLabel.text = time[indexPath.row-1]
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
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegate 
extension EPGViewController : UICollectionViewDelegate {
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
        
        let index = utils.getCurrentTimeDifferenceInMins() / 15 + 1
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
}

